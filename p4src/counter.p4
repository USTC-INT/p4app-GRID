#ifndef _COUNTER_
#define _COUNTER_
#include "types.p4"
#include "headers.p4"


control WorkerCounter(
    in header_t hdr,
    inout ingress_metadata_t ig_md,
    in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    
    Register<bit<8>,_>(register_size) workers_count;

    RegisterAction<bit<8>, _, bit<8>>(workers_count) workers_count_action = {
        void apply(inout bit<8> value, out bit<8> read_value) {
            read_value = value;

            if (value == 0) {
                value = ig_md.count - 1;
            } else {
                value = value - 1;
            }
        }
    };

    action count_workers_action() {
        ig_md.first_last_flag = workers_count_action.execute(ig_md.register_index); // 1 means last packet; 0 means first packet
    }

    apply {
        count_workers_action();
    }
}

#endif 