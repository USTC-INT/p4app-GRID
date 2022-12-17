#ifndef _FRAGCHECK_
#define _FRAGCHECK_
#include "types.p4"
#include "headers.p4"

control FragCheck(
    in header_t hdr,
    inout ingress_metadata_t ig_md,
    in ingress_intrinsic_metadata_t ig_intr_md) {

    Register<bit<32>,_>(register_size) frag_id; 

    RegisterAction<bit<32>, _, bit<32>>(frag_id) check = {
        void apply(inout bit<32> value, out bit<32> read_value) {
            if(value==0 || value == hdr.ina.frag_id){ // legal
                value = hdr.ina.frag_id;
                read_value=value;
            }
            else{ // ilegal
                read_value=value;
            }
        }
    };
    
    RegisterAction<bit<32>, _, bit<32>>(frag_id) reset = {
        void apply(inout bit<32> value, out bit<32> read_value) {
            value=0;
            read_value=value;
        }
    };

    action check_frag_id_action() {
        ig_md.frag_id=check.execute(ig_md.register_index);
    }

    action reset_frag_id_action(){
        ig_md.frag_id = reset.execute(ig_md.register_index);
    }
    
    table frag_check {
        key = {
            ig_intr_md.resubmit_flag : exact;
        }
        actions = {
            check_frag_id_action;
            reset_frag_id_action;
            @defaultonly NoAction;
        }

        const entries ={
            (0) : check_frag_id_action();
            (1) : reset_frag_id_action();
        }

        const default_action = NoAction;
    }

    apply {
        frag_check.apply();
    }
}

#endif 