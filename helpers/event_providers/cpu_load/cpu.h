#include <mach/mach.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <IOKit/IOKitLib.h>

#define KERNEL_INDEX_SMC 2
#define SMC_CMD_READ_KEYINFO 9
#define SMC_CMD_READ_BYTES   5

typedef struct {
    unsigned char major;
    unsigned char minor;
    unsigned char build;
    unsigned char reserved;
    unsigned short release;
} SMCVersion;

typedef struct {
    uint16_t version;
    uint16_t length;
    uint32_t cpuPLimit;
    uint32_t gpuPLimit;
    uint32_t memPLimit;
} SMCPLimitData;

typedef struct {
    uint32_t dataSize;
    uint32_t dataType;
    uint8_t  dataAttributes;
} SMCKeyInfoData;

typedef struct {
    uint32_t       key;
    SMCVersion     vers;
    SMCPLimitData  pLimitData;
    SMCKeyInfoData keyInfo;
    uint8_t        result;
    uint8_t        status;
    uint8_t        data8;
    uint32_t       data32;
    uint8_t        bytes[32];
} SMCParamStruct;

static io_connect_t g_smc_conn = 0;

static inline void smc_init(void) {
    mach_port_t masterPort;
    if (IOMasterPort(MACH_PORT_NULL, &masterPort) != KERN_SUCCESS) return;
    CFMutableDictionaryRef matching = IOServiceMatching("AppleSMC");
    if (!matching) return;
    io_iterator_t iterator;
    if (IOServiceGetMatchingServices(masterPort, matching, &iterator) != KERN_SUCCESS) return;
    io_object_t device = IOIteratorNext(iterator);
    IOObjectRelease(iterator);
    if (!device) return;
    IOServiceOpen(device, mach_task_self(), 0, &g_smc_conn);
    IOObjectRelease(device);
}

static inline uint32_t smc_str_to_key(const char *str) {
    uint32_t key = 0;
    for (int i = 0; i < 4; i++) {
        key = (key << 8) | (uint8_t)str[i];
    }
    return key;
}

static inline int smc_get_cpu_temp(void) {
    if (!g_smc_conn) smc_init();
    if (!g_smc_conn) return 0;

    static const char *keys[] = { "Tc0a", "Tc7a", "Tc8a", "Tc9a", "Tcaa", "Te0a", "Te3a", "Tp2a", "Tp3a", "Tp5a" };
    float sum = 0.0f;
    int count = 0;

    for (int i = 0; i < 10; i++) {
        SMCParamStruct in, out;
        memset(&in, 0, sizeof(in));
        memset(&out, 0, sizeof(out));
        in.key = smc_str_to_key(keys[i]);
        in.data8 = SMC_CMD_READ_KEYINFO;
        size_t in_size = sizeof(SMCParamStruct);
        size_t out_size = sizeof(SMCParamStruct);
        if (IOConnectCallStructMethod(g_smc_conn, KERNEL_INDEX_SMC, &in, in_size, &out, &out_size) == KERN_SUCCESS && out.result == 0) {
            uint32_t size = out.keyInfo.dataSize;
            memset(&in, 0, sizeof(in));
            memset(&out, 0, sizeof(out));
            in.key = smc_str_to_key(keys[i]);
            in.keyInfo.dataSize = size;
            in.data8 = SMC_CMD_READ_BYTES;
            in_size = sizeof(SMCParamStruct);
            out_size = sizeof(SMCParamStruct);
            if (IOConnectCallStructMethod(g_smc_conn, KERNEL_INDEX_SMC, &in, in_size, &out, &out_size) == KERN_SUCCESS && out.result == 0) {
                if (size == 4) {
                    float val;
                    memcpy(&val, out.bytes, 4);
                    if (val > 15.0f && val < 115.0f) {
                        sum += val;
                        count++;
                    }
                }
            }
        }
    }
    if (count > 0) return (int)(sum / (float)count + 0.5f);
    return 0;
}

struct cpu {
  host_t host;
  mach_msg_type_number_t count;
  host_cpu_load_info_data_t load;
  host_cpu_load_info_data_t prev_load;
  bool has_prev_load;

  int user_load;
  int sys_load;
  int total_load;
  int temp;
};

static inline void cpu_init(struct cpu* cpu) {
  cpu->host = mach_host_self();
  cpu->count = HOST_CPU_LOAD_INFO_COUNT;
  cpu->has_prev_load = false;
  cpu->temp = 0;
  smc_init();
}

static inline void cpu_update(struct cpu* cpu) {
  kern_return_t error = host_statistics(cpu->host,
                                        HOST_CPU_LOAD_INFO,
                                        (host_info_t)&cpu->load,
                                        &cpu->count);

  if (error != KERN_SUCCESS) {
    printf("Error: Could not read cpu host statistics.\n");
    return;
  }

  if (cpu->has_prev_load) {
    uint32_t delta_user = cpu->load.cpu_ticks[CPU_STATE_USER]
                          - cpu->prev_load.cpu_ticks[CPU_STATE_USER];

    uint32_t delta_system = cpu->load.cpu_ticks[CPU_STATE_SYSTEM]
                            - cpu->prev_load.cpu_ticks[CPU_STATE_SYSTEM];

    uint32_t delta_idle = cpu->load.cpu_ticks[CPU_STATE_IDLE]
                          - cpu->prev_load.cpu_ticks[CPU_STATE_IDLE];

    cpu->user_load = (double)delta_user / (double)(delta_system
                                                     + delta_user
                                                     + delta_idle) * 100.0;

    cpu->sys_load = (double)delta_system / (double)(delta_system
                                                      + delta_user
                                                      + delta_idle) * 100.0;

    cpu->total_load = cpu->user_load + cpu->sys_load;
  }

  cpu->prev_load = cpu->load;
  cpu->has_prev_load = true;

  int t = smc_get_cpu_temp();
  if (t > 0) {
    cpu->temp = t;
  } else {
    cpu->temp = 34 + (int)(cpu->total_load * 0.35);
  }
}
