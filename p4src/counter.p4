#ifndef _COUNTER_
#define _COUNTER_
#include "types.p4"
#include "headers.p4"


control WorkerCounter(
    in header_t hdr,
    inout ingress_metadata_t ig_md,
    in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    
    Register<bit<8>,index_t>(register_size) workers_count;

    RegisterAction<bit<8>, index_t, bit<8>>(workers_count) workers_count_action = {
        // 1 means last packet; 0 means first packet
        void apply(inout bit<8> value, out bit<8> read_value) {
            // Only works with jobs of 2 workers or more
            read_value = value;

            if (value == 0) {
                value = ig_md.count - 1;
            } else {
                value = value - 1;
            }
        }
    };

    action count_workers_action() {
        ig_md.first_last_flag = workers_count_action.execute(ig_md.register_index);
    }

    // RegisterAction<bit<8>, index_t, bit<8>>(workers_count) read_workers_count_action = {
    //     void apply(inout bit<8> value, out bit<8> read_value) {
    //         read_value = value;
    //     }
    // };
    
    table count_workers{
        actions = {
            count_workers_action;
        }

        default_action = count_workers_action;
    }

    apply {
        count_workers.apply();
    }
}

#endif 