#ifndef _PROCESSOR_
#define _PROCESSOR_
#include "types.p4"
#include "headers.p4"


control Processor(
    in data_t value_in,
    out data_t value_out,
    in ingress_metadata_t ig_md) {

    Register<data_t,_>(register_size) gradient; 

    RegisterAction<data_t, _, data_t>(gradient) aggregate = {
        void apply(inout data_t value, out data_t read_value) {
            if(ig_md.first_last_flag == 0){ //first packet
                value=value_in;
            }
            else{
                value = value + value_in;
            }
            read_value = value;
        }
    };
    
    action aggregating_action() {
        value_out = aggregate.execute(ig_md.register_index);
    }

    apply {
        aggregating_action();
    }
}

#endif 