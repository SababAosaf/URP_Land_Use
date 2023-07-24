%  Copyright (c) 2018, Nusrat Sharmin
%  All rights reserved.
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.

classdef  (Sealed) land_data_excel_columns
    properties  (Constant)
        serial_no = 1;
        plot_ID = 2;
        block_no = 3;
        landuse_code = 4;
        change = 5;
        bldg_storey = 6;
        no_of_unit = 7;
        resgr = 8;
        res1 = 9;
        res2 = 10;
        res3 = 11;
        res4 = 12;
        res5 = 13;
        res6 = 14;
        res7 = 15;
        res8 = 16;
        res9 = 17;
        res10 = 18;
        res11 = 19;
        res12 = 20;
        res13 = 21;
        comgr = 22;
        com1 = 23;
        com2 = 24;
        com3 = 25;
        com4 = 26;
        com5 = 27;
        com6 = 28;
        com7 = 29;
        com8 = 30;
        com9 = 31;
        com10 = 32;
        com11 = 33;
        com12 = 34;
        com13 = 35;
        offgr = 36;
        off1 = 37;
        off2 = 38;
        off3 = 39;
        off4 = 40;
        off5 = 41;
        off6 = 42;
        off7 = 43;
        off8 = 44;
        off9 = 45;
        off10 = 46;
        off11 = 47;
        off12 = 48;
        off13 = 49;
        schclggr = 50;
        schclg1 = 51;
        schclg2 = 52;
        schclg3 = 53;
        schclg4 = 54;
        schclg5 = 55;
        schclg6 = 56;
        schclg7 = 57;
        schclg8 = 58;
        schclg9 = 59;
        schclg10 = 60;
        schclg11 = 61;
        schclg12 = 62;
        schclg13 = 63;
        unigr = 64;
        uni1 = 65;
        uni2 = 66;
        uni3 = 67;
        uni4 = 68;
        uni5 = 69;
        uni6 = 70;
        uni7 = 71;
        uni8 = 72;
        uni9 = 73;
        uni10 = 74;
        uni11 = 75;
        uni12 = 76;
        uni13 = 77;
        healthgr = 78;
        health1 = 79;
        health2 = 80;
        health3 = 81;
        health4 = 82;
        health5 = 83;
        health6 = 84;
        health7 = 85;
        health8 = 86;
        health9 = 87;
        health10 = 88;
        health11 = 89;
        health12 = 90;
        health13 = 91;
        civicgr = 92;
        civic1 = 93;
        civic2 = 94;
        civic3 = 95;
        civic4 = 96;
        civic5 = 97;
        civic6 = 98;
        civic7 = 99;
        civic8 = 100;
        civic9 = 101;
        civic10 = 102;
        civic11 = 103;
        civic12 = 104;
        civic13 = 105;
        parking = 106;
        tot_bldg_res = 107;
        tot_bldg_com = 108;
        tot_bldg_off = 109;
        tot_bldg_schclg = 110;
        tot_bldg_uni = 111;
        tot_bldg_health = 112;
        tot_bldg_civic = 113;
        total_floor_space = 114;
        res = 115;
        com = 116;
        off = 117;
        plot_size = 118;
        ln_tot_plot_size = 119;
        lake_view = 120;
        mkt_price_per_sq_ft = 121;
        ln_mkt_price = 122;
        percent_of_com_use_block_floor_space = 123;
        percent_of_ofc_use_block_floor_space = 124;
        percent_of_civic_use_block_floor_space = 125;
        adjacent_major_rd = 126;
        distant_to_nwmkt = 127;
        ln_distant_to_nwmkt = 128;
        num_uni_per10000sqft = 129;
    end
    
    methods (Access = private)
        function obj = land_data_excel_columns
        end
    end
end
