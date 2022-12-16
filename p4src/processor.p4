#ifndef _PROCESSOR_
#define _PROCESSOR_
#include "types.p4"
#include "headers.p4"


control Processor(
    in data_t value_in,
    out data_t value_out,
    in ingress_metadata_t ig_md) {

    Register<data_t,index_t>(register_size) gradient; 

    RegisterAction<data_t, index_t, data_t>(gradient) sum_read_value = {
        void apply(inout data_t value, out data_t out_value) {
            if(ig_md.first_last_flag == 0){ //first packet
                value=value_in;
            }
            else{
                value = value + value_in;
            }
            out_value = value;
        }
    };
    
    action sum_read_action() {
        value_out = sum_read_value.execute(ig_md.index);
    }

    apply {
        sum_read_action();
    }
}

#endif 