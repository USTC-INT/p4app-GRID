/* -*- P4_16 -*- */
#include <core.p4>
#if __TARGET_TOFINO__ == 2
#include <t2na.p4>
#else
#include <tna.p4>
#endif

#include "parser.p4"
#include "headers.p4"
#include "processor.p4"
#include "types.p4"
#include "config.p4"
#include "fragcheck.p4"
#include "counter.p4"

control Ingress(
        inout header_t hdr,
        inout ingress_metadata_t ig_md,
        in ingress_intrinsic_metadata_t ig_intr_md,
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {
    
    action set_agg() {
        ig_md.is_aggregation = 1;
    }

    action unset_agg() {
        ig_md.is_aggregation = 0;
    }
    
    table switch_check {
        key = {
            hdr.ina.switch_id: exact;
        }
        actions = {
            set_agg;
            unset_agg;
        }
        size = 1;
        default_action = unset_agg;
    }
   
    action drop() {
        ig_dprsr_md.drop_ctl = 1;
    }
    
    action ipv4_forward(mac_addr_t dst_addr, egress_spec_t port) {
        ig_tm_md.ucast_egress_port = port;
        // hdr.ethernet.src_addr = hdr.ethernet.dst_addr;
        // hdr.ethernet.dst_addr = dst_addr;
        // hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }
    
    table forward {
        key = {
            hdr.ipv4.dst_addr: exact;
        }
        actions = {
            ipv4_forward;
            drop;
        }
        default_action = drop;
    }

    FragCheck() frag_check;

    WorkerCounter() worker_counter;

    Processor() value00;
    Processor() value01;
    Processor() value02;
    Processor() value03;
    Processor() value04;
    Processor() value05;
    Processor() value06;
    Processor() value07;
    Processor() value08;
    Processor() value09;
    Processor() value10;
    Processor() value11;
    Processor() value12;
    Processor() value13;
    Processor() value14;
    Processor() value15;
    Processor() value16;
    Processor() value17;
    Processor() value18;
    Processor() value19;
    Processor() value20;
    Processor() value21;
    Processor() value22;
    Processor() value23;
    Processor() value24;
    Processor() value25;
    Processor() value26;
    Processor() value27;
    Processor() value28;
    Processor() value29;
    Processor() value30;
    Processor() value31;

    apply {
        if(hdr.ina.isValid()) {
            if (hdr.ina.is_ack == 1){ // directly forward packets from the PS
                forward.apply();
            } 
            else {
                switch_check.apply();

                if(ig_md.is_aggregation == 0 ){
                    forward.apply();
                } 
                else { // start processing
                    
                    frag_check.apply(hdr, ig_md, ig_intr_md);
                    
                    if (ig_intr_md.resubmit_flag == 0){
                        if ( ig_md.frag_id == hdr.ina.frag_id){
                            //aggregating
                            worker_counter.apply(hdr,ig_md,ig_dprsr_md);

                            value00.apply(hdr.gradient.value00,hdr.gradient.value00,ig_md);
                            value01.apply(hdr.gradient.value01,hdr.gradient.value01,ig_md);
                            value02.apply(hdr.gradient.value02,hdr.gradient.value02,ig_md);
                            value03.apply(hdr.gradient.value03,hdr.gradient.value03,ig_md);
                            value04.apply(hdr.gradient.value04,hdr.gradient.value04,ig_md);
                            value05.apply(hdr.gradient.value05,hdr.gradient.value05,ig_md);
                            value06.apply(hdr.gradient.value06,hdr.gradient.value06,ig_md);
                            value07.apply(hdr.gradient.value07,hdr.gradient.value07,ig_md);
                            value08.apply(hdr.gradient.value08,hdr.gradient.value08,ig_md);
                            value09.apply(hdr.gradient.value09,hdr.gradient.value09,ig_md);
                            value10.apply(hdr.gradient.value10,hdr.gradient.value10,ig_md);
                            value11.apply(hdr.gradient.value11,hdr.gradient.value11,ig_md);
                            value12.apply(hdr.gradient.value12,hdr.gradient.value12,ig_md);
                            value13.apply(hdr.gradient.value13,hdr.gradient.value13,ig_md);
                            value14.apply(hdr.gradient.value14,hdr.gradient.value14,ig_md);
                            value15.apply(hdr.gradient.value15,hdr.gradient.value15,ig_md);
                            value16.apply(hdr.gradient.value16,hdr.gradient.value16,ig_md);
                            value17.apply(hdr.gradient.value17,hdr.gradient.value17,ig_md);
                            value18.apply(hdr.gradient.value18,hdr.gradient.value18,ig_md);
                            value19.apply(hdr.gradient.value19,hdr.gradient.value19,ig_md);
                            value20.apply(hdr.gradient.value20,hdr.gradient.value20,ig_md);
                            value21.apply(hdr.gradient.value21,hdr.gradient.value21,ig_md);
                            value22.apply(hdr.gradient.value22,hdr.gradient.value22,ig_md);
                            value23.apply(hdr.gradient.value23,hdr.gradient.value23,ig_md);
                            value24.apply(hdr.gradient.value24,hdr.gradient.value24,ig_md);
                            value25.apply(hdr.gradient.value25,hdr.gradient.value25,ig_md);
                            value26.apply(hdr.gradient.value26,hdr.gradient.value26,ig_md);
                            value27.apply(hdr.gradient.value27,hdr.gradient.value27,ig_md);
                            value28.apply(hdr.gradient.value28,hdr.gradient.value28,ig_md);
                            value29.apply(hdr.gradient.value29,hdr.gradient.value29,ig_md);
                            value30.apply(hdr.gradient.value30,hdr.gradient.value30,ig_md);
                            value31.apply(hdr.gradient.value31,hdr.gradient.value31,ig_md);

                            if(ig_md.first_last_flag == 1){ // resubmit the last packet
                                ig_dprsr_md.resubmit_type = 1;
                            }
                        }
                        else{
                            drop();
                        }
                        
                    }
                    else{
                        forward.apply();
                    }
                }
            }
        } 
        else if (hdr.ipv4.isValid()) {
            forward.apply();
        }
        else{
            drop();
        }
    }
}

control Egress(
        inout header_t hdr,
        inout egress_metadata_t eg_md,
        in egress_intrinsic_metadata_t eg_intr_md,
        in egress_intrinsic_metadata_from_parser_t eg_intr_md_from_prsr,
        inout egress_intrinsic_metadata_for_deparser_t ig_intr_dprs_md,
        inout egress_intrinsic_metadata_for_output_port_t eg_intr_oport_md) {
    apply {}
}

Pipeline(IngressParser(),
         Ingress(),
         IngressDeparser(),
         EgressParser(),
         Egress(),
         EgressDeparser()) pipe;

Switch(pipe) main;