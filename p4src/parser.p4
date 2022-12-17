#ifndef _PARSERS_
#define _PARSERS_

#include <core.p4>
#if __TARGET_TOFINO__ == 2
#include <t2na.p4>
#else
#include <tna.p4>
#endif

#include "headers.p4"
#include "types.p4"


parser IngressParser(
        packet_in pkt,
        out header_t hdr,
        out ingress_metadata_t ig_md,
        out ingress_intrinsic_metadata_t ig_intr_md) {

    state start {
        pkt.extract(ig_intr_md);
        transition select(ig_intr_md.resubmit_flag){
            1: parse_resubmit;
            0: parse_port_metadata;
        }
    }

    state parse_resubmit{
        pkt.extract(ig_md.resubmit_data);
        transition parse_ethernet;
    }

    state parse_port_metadata{
        pkt.advance(PORT_METADATA_SIZE);
        transition parse_ethernet;
    }

    state parse_ethernet {
        pkt.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            TYPE_IPV4: parse_ipv4;
            default: accept;
        }
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            TYPE_INA: parse_ina;
            default: accept;
        }
    }

    state parse_ina {
        pkt.extract(hdr.ina);
        
        ig_md.register_index=hdr.ina.register_index;
        ig_md.count=hdr.ina.count;
        ig_md.frag_id  = hdr.ina.frag_id;
        
        pkt.extract(hdr.gradient);

        transition accept;
    }
}

control IngressDeparser(
        packet_out pkt,
        inout header_t hdr,
        in ingress_metadata_t ig_md,
        in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    
    Checksum() ipv4_checksum;

    Resubmit() resubmit;
    
    apply {
        
        if (ig_dprsr_md.resubmit_type == 1) {
            resubmit.emit();
        } else if (ig_dprsr_md.resubmit_type == 2) {
            resubmit.emit(ig_md.resubmit_data);
        }

        if(hdr.ipv4.isValid()){
            hdr.ipv4.hdr_checksum = ipv4_checksum.update({
                hdr.ipv4.version,
                hdr.ipv4.ihl,
                hdr.ipv4.diffserv,
                hdr.ipv4.total_len,
                hdr.ipv4.identification,
                hdr.ipv4.flags,
                hdr.ipv4.frag_offset,
                hdr.ipv4.ttl,
                hdr.ipv4.protocol,
                hdr.ipv4.src_addr,
                hdr.ipv4.dst_addr
            });
        }
        pkt.emit(hdr);
    }
}

parser EgressParser(
        packet_in pkt,
        out header_t hdr,
        out egress_metadata_t eg_md,
        out egress_intrinsic_metadata_t eg_intr_md) {
    state start {
        pkt.extract(eg_intr_md);
        transition accept;
    }
}

control EgressDeparser(
        packet_out pkt,
        inout header_t hdr,
        in egress_metadata_t eg_md,
        in egress_intrinsic_metadata_for_deparser_t ig_intr_dprs_md) {
    apply {
        pkt.emit(hdr);
    }
}

#endif