#ifndef _FRAGCHECK_
#define _FRAGCHECK_
#include "types.p4"
#include "headers.p4"


control FragCheck(
    in header_t hdr,
    inout ingress_metadata_t ig_md,
    in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    
    Register<bit<32>,index_t>(register_size) frag_id; 

    RegisterAction<bit<32>, index_t, bit<32>>(frag_id) check_frag_id = {
        void apply(inout bit<32> value, out bit<32> read_value) {
            if(value==0 || value == hdr.frag_id){ // legal
                
                worker_counter.apply(hdr,ig_md,ig_dprsr_md);
                
                if (ig_md.first_last_flag == 1){ //last packets 
                    value=0; //reset
                }
                else{
                    value = hdr.frag_id;
                }

                read_value=value;
            }
            else{ // ilegal
                read_value=value;
            }
        }
    };
    
    action check_frag_id_action() {
        ig_md.frag_id=check_frag_id.execute(ig_md.register_index);
    }

    table check_frag {
       
        actions = {
            check_frag_id_action;
        }

        const default_action = check_frag_id_action;
    }

    WorkerCounter() worker_counter;
    
    apply {
        check_frag.apply();
    }
}

#endif 