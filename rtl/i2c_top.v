`include "register_interface/typedef.svh"
`include "register_interface/assign.svh"

module i2c_top
    #(
      parameter int unsigned AXI_ADDR_WIDTH = 32,
      localparam int unsigned AXI_DATA_WIDTH = 32,
      parameter int unsigned AXI_ID_WIDTH,
      parameter int unsigned AXI_USER_WIDTH
      )
(
    input clk_i,
    input rst_ni,

    AXI_BUS.Slave axi_slave,

    input wire i2c_scl_i,
    input wire i2c_scl_o,
    output wire i2c_scl_t,
    input wire i2c_sda_i,
    output wire i2c_sda_o,
    output wire i2c_sda_t

);

    logic testmode_i;
    assign testmode_i = 0;


    AXI_LITE #(.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH), .AXI_DATA_WIDTH(AXI_DATA_WIDTH)) master();


    axi_to_axi_lite_intf #(.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
                           .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
                           .AXI_ID_WIDTH(AXI_ID_WIDTH),
                           .AXI_USER_WIDTH(AXI_USER_WIDTH))
                           i_axi2_axil (
                            .clk_i(clk_i),
                            .rst_ni(rst_ni),
                            .testmode_i(testmode_i),
                            .slv(axi_slave),
                            .mst(master)
                           );

    logic rst;
    assign rst = !rst_ni;

    i2c_master_axil #(.DEFAULT_PRESCALE(1),
                      .FIXED_PRESCALE(0),
                      .CMD_FIFO(1),
                      .CMD_FIFO_ADDR_WIDTH(5),
                      .WRITE_FIFO(1),
                      .WRITE_FIFO_ADDR_WIDTH(5),
                      .READ_FIFO(1),
                      .READ_FIFO_ADDR_WIDTH(5))
               i_i2c_master_axil(
                .clk(clk_i),
                .rst(rst),
                .s_axil_awvalid(master.aw_valid),
                .s_axil_awready(master.aw_ready),
                .s_axil_awaddr(master.aw_addr),
                .s_axil_awprot(master.aw_prot),
                .s_axil_wvalid(master.w_valid),
                .s_axil_wready(master.w_ready),
                .s_axil_wdata(master.w_data),
                .s_axil_wstrb(master.w_strb),
                .s_axil_bvalid(master.b_valid),
                .s_axil_bready(master.b_ready),
                .s_axil_bresp(master.b_resp),
                .s_axil_arvalid(master.ar_valid),
                .s_axil_arready(master.ar_ready),
                .s_axil_araddr(master.ar_addr),
                .s_axil_arprot(master.ar_prot),
                .s_axil_rvalid(master.r_valid),
                .s_axil_rready(master.r_ready),
                .s_axil_rdata(master.r_data),
                .s_axil_rresp(master.r_resp),

                .i2c_scl_i(i2c_scl_i),
                .i2c_scl_o(i2c_scl_o),
                .i2c_scl_t(i2c_scl_t),
                .i2c_sda_i(i2c_sda_i),
                .i2c_sda_o(i2c_sda_o),
                .i2c_sda_t(i2c_sda_t)
               );
endmodule

