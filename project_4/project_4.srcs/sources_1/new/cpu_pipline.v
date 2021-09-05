`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/23 20:16:49
// Design Name: 
// Module Name: cpu_pipline
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "defines.v"

/*主要按顺序存储文件*/
module pc_reg (
    input   clk,
    input   rst,
    input   jump_flag_ex_i,
    input   [`InstAddrBus]      jump_addr_ex_i,

    output  reg[`InstAddrBus]   pc,
    output  reg                 ce 
);
    always @(posedge clk) begin
        if (ce==`ChipDisable)
        begin
            pc <= 32'h0;
        end 
        else if(jump_flag_ex_i == `JumpEnable)begin
            pc <= jump_addr_ex_i + 4'h4;
        end
        else begin
            //pc <= pc+ 32'h4;还是下面这个
            pc <= pc+ 4'h4;
        end
    end

    always @(posedge clk) begin
        if(rst==`RstEnable)
        begin
            ce <= `ChipDisable;
        end
        else
        begin
            ce <= `ChipEnable;
        end
    end
endmodule


/*这个模块好鸡肋啊，主要是将上个取指的命令存下来*/
module if_id (
    input   clk,
    input   rst,
    input   [`InstAddrBus]      if_pc,
    input   [`InstBus]          if_inst,

    output  reg[`InstAddrBus]   id_pc,
    output  reg[`InstBus]       id_inst

);
    always @(posedge clk) begin
        if(rst == `RstEnable)
        begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else
        begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end
endmodule


//取数据
//regfile模块实现32个32位通用寄存器，
//可以同时进行两个寄存器的读操作和一个寄存器的写操作
module regfile (
    //控制信号
    input       clk,
    input       rst,

    //写端口
    //we为写使能， waddr为先行的地址，wdata为先行的数据
    input                   we,
    input   [`RegAddrBus]   waddr,
    input   [`RegBus]       wdata,

    //读端口1
    //re为读使能
    input                   re1,
    input   [`RegAddrBus]   raddr1,
    output  reg[`RegBus]    rdata1,

    //读端口1
    input                   re2,
    input   [`RegAddrBus]   raddr2,
    output  reg[`RegBus]    rdata2
);
    //创建32个32位的通用寄存器，储存所有调用过的寄存器
    reg [`RegBus]    regs[0:`RegNum-1];
    //&&是与，&是按位与
    //||是或，|是按位或

    //写操作，时序操作，每当有上升沿才进行写数据
    always @(posedge clk) begin
        if(rst == `RstDisable) begin
            if((we == `WriteEnable) && (waddr != `RegNumlog2'h0)) begin
                regs[waddr] <= wdata;
            end
        end
    end

    //读寄存器，任何变化都
    //有两种方式读到数据
    //1，通过waddr从写使能中读取
    //2，通过从32位寄存器的储存器中，通过addr读取数据
    always @(*) begin
        if(rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if(raddr1 == 5'h0) begin
            rdata1 <= `ZeroWord;
        end else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable))begin
            //传入的是上面刚刚写入的值
            rdata1 <= wdata;
        end else if(re1 == `ReadEnable) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end
    always @(*) begin
        if(rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if(raddr2 == 5'h0) begin
            rdata2 <= `ZeroWord;
        end else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable))begin
            rdata2 <= wdata;
        end else if(re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
endmodule


//译码，将指令进行每个字段的含义取出
module id (
    input                       rst,
    input   [`InstAddrBus]      pc_i,   //instruction addr 32
    input   [`InstBus]          inst_i,//instruction 32
    
    //read regfile
    input   [`RegBus]           reg1_data_i,
    input   [`RegBus]           reg2_data_i,

    //ouput to regfile
    output  reg                 reg1_read_o,    //reg1 read enable 1
    output  reg                 reg2_read_o,    //reg2 read enable 1
    output  reg[`RegAddrBus]    reg1_addr_o, //reg1 addr signal 5 2^5
    output  reg[`RegAddrBus]    reg2_addr_o, //reg2 addr signal 5 2^5

    //retrun to exe
    output  reg[`AluOpBus]      aluop_o,
    output  reg[`AluSelBus]     alusel_o,
    output  reg[`RegBus]        reg1_o,   //original instruction1 32
    output  reg[`RegBus]        reg2_o,    //original instruction2 32
    output  reg[`RegAddrBus]    wd_o,   //addr 5 write  into reg
    output  reg                 wreg_o,  //wethier write into?
    output  reg[`RegBus]        imm,
    wire    [6:0]   opcode,
    wire    [2:0]   funct3 
);

    /*不同类型的指令首先通过opcode字段判定属于哪类指令
    再通过funct3字段判定该指令具有什么样的功能，
    部分指令只需要判断opcode就能确认，但大部分指令还是需要判断两者才能确认*/
    assign  opcode = inst_i[6:0];
    wire    [4:0]   rd = inst_i[11:7];
    assign  funct3 = inst_i[14:12];
    wire    [4:0]   rs1 = inst_i[19:15]; //rs1(this)  rsl
    wire    [4:0]   rs2 = inst_i[24:20]; //rs2(this)  rsl
    //instvalid目前还没有用到
    reg             instvalid;

/*Q：判断条件出问题了，条件没有进行正确判断，全部都直接调到默认的else上了*/
//A:可以判断opcode的判断条件写错了，写成了ALU的判断了，应该写EXE的
    always @(*) begin
        if(rst == `RstEnable) begin
            aluop_o     <=  `ALU_NOP_OP;
            alusel_o    <=  `EXE_RES_NOP;
            wd_o        <=  `NOPRegAddr;
            wreg_o      <=  `WriteDisable;
            instvalid   <=  `InstValid;
            reg1_read_o <=  1'b0;
            reg2_read_o <=  1'b0;
            reg1_addr_o <=  `NOPRegAddr;
            reg2_addr_o <=  `NOPRegAddr;
            imm         <=  32'h0;
        end else if((opcode == `EXE_OR_OP) && (funct3 == `EXE_ORI)) begin
            wreg_o      <=  `WriteEnable;
            aluop_o     <=  `ALU_ORI_OP;
            alusel_o    <=  `EXE_RES_LOGIC;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b0;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rd;
            wd_o        <=  rd;
            instvalid   <=  `InstValid;
            imm         <=  {{20{inst_i[31]}}, inst_i[31:20]};//{a,b}将ab按顺序接到一起，｛20a｝,将20个a接到一起，这里指的是01bit接到一起
            //imm         <=  32'h0000_00ff;

        end else if ((opcode == `EXE_LW_OP) && (funct3 == `EXE_LW)) begin
            /*同样是I型指令，我这样写应该没事儿吧*/
            wreg_o      <=  `WriteEnable;
            aluop_o     <=  `ALU_LW_OP;
            alusel_o    <=  `EXE_RES_LOAD;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b0;
            reg1_addr_o <=  rs1;
            // 不晓得为啥要将reg2addr设为rd，通过实验证明有reg2_read_o为0的控制，rd为何值都无所谓，要不要这条赋值语句都行，可能是有些特殊用途吧
            reg2_addr_o <=  rd;
            wd_o        <=  rd;
            instvalid   <=  `InstValid;
            imm         <=  {{20{inst_i[31]}}, inst_i[31:20]};

        end else if(opcode == `EXE_U_LUI_OP)begin
            aluop_o     <=  `ALU_LUI_OP;
            alusel_o    <=  `EXE_RES_LOGIC;
            wd_o        <=  rd;
            wreg_o      <=  `WriteEnable;
            instvalid   <=  `InstValid;
            reg1_read_o <=  1'b0;
            reg2_read_o <=  1'b0;
            reg1_addr_o <=  `NOPRegAddr;
            reg2_addr_o <=  rd;
            imm         <=  {inst_i[31:12], 12'b0};
        end else if((opcode == `EXE_R_OP) && (funct3 == `EXE_ADD))begin
            aluop_o     <=  `ALU_ADD_OP;
            alusel_o    <=  `EXE_RES_ARITH;
            instvalid   <=  `InstValid;
            wd_o        <=  rd;
            wreg_o      <=  `WriteEnable;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b1;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rs2;
            imm         <=  `ZeroWord;
        end else if((opcode == `EXE_R_OP) && (funct3 == `EXE_SLT))begin
            aluop_o     <=  `ALU_SLT_OP;
            alusel_o    <=  `EXE_RES_ARITH;
            instvalid   <=  `InstValid;
            wd_o        <=  rd;
            wreg_o      <=  `WriteEnable;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b1;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rs2;
            imm         <=  `ZeroWord;
        end else if((opcode == `EXE_R_OP) && (funct3 == `EXE_SLTU))begin
            aluop_o     <=  `ALU_SLTU_OP;
            alusel_o    <=  `EXE_RES_ARITH;
            instvalid   <=  `InstValid;
            wd_o        <=  rd;
            wreg_o      <=  `WriteEnable;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b1;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rs2;
            imm         <=  `ZeroWord;
        end else if((opcode == `EXE_SW_OP) && (funct3 == `EXE_SW))begin
            aluop_o     <=  `ALU_SW_OP;
            alusel_o    <=  `EXE_RES_LOAD;
            instvalid   <=  `InstValid;
            //wd_o        <=  rd;
            wreg_o      <=  `WriteEnable;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b1;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rs2;
            imm         <=  {{20{1'b0}}, inst_i[31:25], inst_i[11:7]};
        end else if (opcode == `EXE_JAL_OP) begin
            aluop_o     <=  `ALU_JAL_OP;
            alusel_o    <=  `EXE_RES_JUMP;
            instvalid   <=  `InstValid;
            wd_o        <=  rd;
            wreg_o      <=  `WriteEnable;
            reg1_read_o <=  1'b0;
            reg2_read_o <=  1'b0;
            //最末尾的1'b0相当于将指令扩展后的两倍，即左移一位
            imm         <=  {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            //设置固定的跳两个指令
            imm[3]         <=  1'b1;
        end else if ((opcode == `EXE_BEQ_OP) && (funct3 == `EXE_BEQ)) begin
            aluop_o     <=  `ALU_BEQ_OP;
            alusel_o    <=  `EXE_RES_NOP;
            instvalid   <=  `InstValid;
            wd_o        <=  rd;
            wreg_o      <=  `WriteDisable;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rs2;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b1;
            imm         <=  {{12{inst_i[31]}}, inst_i[7], inst_i[30:26], inst_i[11:8], 1'b0};
        end
        else begin
            aluop_o     <=  `ALU_ORI_OP;
            alusel_o    <=  `EXE_RES_NOP;
            reg1_read_o <=  1'b1;
            reg2_read_o <=  1'b1;
            reg1_addr_o <=  rs1;
            reg2_addr_o <=  rs2;
            wd_o        <=  rd;
            instvalid   <=  `InstValid;
            imm         <=  `ZeroWord;
            //imm         <=  32'h0000_00ff;
        end
    end

    always @(*) begin
        if(rst == `RstEnable) begin
            reg1_o  = `ZeroWord;
        end else if(reg1_read_o == 1'b1)begin
            reg1_o <= reg1_data_i;
        end else if(reg1_read_o == 1'b0)begin
            reg1_o <= imm;
        end else begin
            reg1_o <= `ZeroWord;
        end
    end
    always @(*) begin
        if(rst == `RstEnable) begin
            reg2_o  = `ZeroWord;
        end else if(reg2_read_o == 1'b1)begin
            reg2_o <= reg2_data_i;
        end else if(reg2_read_o == 1'b0)begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZeroWord;
        end
    end
endmodule


//将译码阶段的到传到执行阶段
//单独设置一个module的原因是，为了用rst信号更加方便控制信号
module id_ex (
    input       clk,
    input       rst,

    //从译码器中的得到传递信息
    input   [`AluOpBus]         id_aluop,
    input   [`AluSelBus]        id_alusel,
    input   [`RegBus]           id_reg1,
    input   [`RegBus]           id_reg2,
    input   [`RegAddrBus]       id_wd,
    input                       id_wreg,
    input   [`RegBus]           id_imm,

    //传递到执行阶段的
    output   reg[`AluOpBus]         ex_aluop,
    output   reg[`AluSelBus]        ex_alusel,
    output   reg[`RegBus]           ex_reg1,
    output   reg[`RegBus]           ex_reg2,
    output   reg[`RegAddrBus]       ex_wd,
    output   reg                    ex_wreg,
    output   reg[`RegBus]           ex_imm 
);
    
    always @(posedge clk) begin
        if(rst == `RstEnable)begin
            ex_aluop    <=  `ALU_NOP_OP;
            ex_alusel   <=  `EXE_RES_NOP;
            ex_reg1     <=  `ZeroWord;
            ex_reg2     <=  `ZeroWord;
            ex_wd       <=  `NOPRegAddr;
            ex_wreg     <=  `WriteDisable;
            ex_imm      <=  `ZeroWord;
        end else begin
            ex_aluop    <=  id_aluop;
            ex_alusel   <=  id_alusel;
            ex_reg1     <=  id_reg1;
            ex_reg2     <=  id_reg2;
            ex_wd       <=  id_wd;
            ex_wreg     <=  id_wreg;
            ex_imm      <=  id_imm;  
        end
    end

endmodule


module ex (
    input   rst,
    input   clk,
    //signal from id从取指模块的得到的命令
    input   [`AluOpBus]         aluop_i,
    input   [`AluSelBus]        alusel_i,
    input   [`RegBus]           imm_i,
    input   [`InstAddrBus]      inst_addr_i,
    
    //要进行计算的两个源操作数
    input   [`RegBus]           reg1_i,
    input   [`RegBus]           reg2_i,
    //要进行写入寄存器的地址
    input   [`RegAddrBus]       wd_i,
    //是否要将结果写入寄存器
    input                       wreg_i,
    //输出
    output  reg[`RegAddrBus]    wd_o,
    output  reg                 wreg_o,
    output  reg[`RegBus]        wdata_o,
    //访存
    output  reg[`AluOpBus]      aluop_o,
    output  reg[`RegBus]        mem_addr_o,
    output  reg[`RegBus]        arithout,
    //jump pc
    output  reg                 jump_flag_o,
    output  reg[`InstAddrBus]   jump_addr_o
);
    reg[`RegBus]    logicout;
    always @(*) begin
        if(rst == `RstEnable)begin
            logicout <= `ZeroWord;
        end else begin
            case (aluop_i)
            //如果操作数为ORI命令，则执行ORI命令
                `ALU_ORI_OP:begin
                    logicout <= reg1_i | reg2_i;
                    aluop_o <= aluop_i;
                    jump_flag_o <= `JumpDisable;
                end
                `ALU_LW_OP:begin
                    mem_addr_o <= reg1_i + reg2_i;
                    aluop_o <= aluop_i;
                    jump_flag_o <= `JumpDisable;
                end
                `ALU_LUI_OP:begin
                    logicout <= reg2_i;
                    jump_flag_o <= `JumpDisable;
                end
                `ALU_ADD_OP:begin
                    arithout <= reg1_i + reg2_i;
                    jump_flag_o <= `JumpDisable;
                end
                `ALU_SW_OP:begin
                    mem_addr_o <= reg1_i + imm_i;
                    wdata_o    <= reg2_i;
                    aluop_o <= aluop_i;
                    jump_flag_o <= `JumpDisable;
                end
                `ALU_JAL_OP:begin
                    jump_flag_o <= `JumpEnable;
                    jump_addr_o <= inst_addr_i + imm_i;
                    wdata_o     <= inst_addr_i + 4'h4;
                end
                `ALU_BEQ_OP:begin
                    if(reg1_i == reg2_i)begin
                        jump_flag_o <= `JumpEnable;
                        jump_addr_o <= inst_addr_i + 4'h4;
                    end else begin
                        jump_flag_o <= `JumpDisable;
                    end
                end
                `ALU_SLT_OP:begin
                    case({reg1_i[31], reg2_i[31]})
                        2'b11:begin
                            if(reg1_i < reg2_i)begin
                                arithout = 32'h0000_0001;
                            end else begin
                                arithout = 32'b0000_0000;
                            end
                        end
                        2'b10:begin
                            arithout = 32'h0000_0001;
                        end
                        2'b01:begin
                            arithout = 32'b0000_0000;
                        end
                        default:begin
                            if(reg1_i < reg2_i)begin
                                arithout = 32'h0000_0001;
                            end else begin
                                arithout = 32'b0000_0000;
                            end
                        end
                    endcase
                    jump_flag_o <= `JumpDisable;
                end
                `ALU_SLTU_OP:begin
                    if(reg1_i < reg2_i)begin
                        arithout = 32'h0000_0001;
                    end else begin
                        arithout = 32'b0000_0000;
                    end
                    jump_flag_o <= `JumpDisable;
                end
                default:begin
                    logicout <= `ZeroWord;
                    jump_flag_o <= `JumpDisable;
                end
            endcase
        end
    end
    always @(*) begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        case(alusel_i)
            `EXE_RES_LOGIC:begin
                wdata_o <= logicout;
            end
            `EXE_RES_ARITH:begin
                wdata_o <= arithout;
            end
            `EXE_RES_LOAD:begin
                ;
            end
            `EXE_RES_JUMP:begin
                ;
            end
            default:begin
                wdata_o <= `ZeroWord;
            end
        endcase
    end
endmodule


//过渡module，主要用于将运算的到值，是否写入目的寄存器进行控制
//进行rst和clk控制
module ex_mem (
    input               clk,
    input               rst,

    //输入
    input   [`RegAddrBus]       ex_wd,
    input                       ex_wreg,
    input   [`RegBus]           ex_wdata,
    input   [`AluOpBus]         aluop_i,
    input   [`RegBus]           mem_addr_i,


    //输出
    output  reg[`RegAddrBus]    mem_wd,
    output  reg                 mem_wreg,
    output  reg[`RegBus]        mem_wdata,
    //访存
    output  reg[`AluOpBus]      aluop_o,
    output  reg[`RegBus]        mem_addr_o
);

    always @(posedge clk) begin
        if(rst == `RstEnable)begin
            mem_wd  <= `NOPRegAddr;
            mem_wreg <= 1'b0;
            mem_wdata <= `ZeroWord;
            aluop_o <= `ALU_NOP_OP;
            mem_addr_o <=`NOPRegAddr;

        end else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            aluop_o <= aluop_i;
            mem_addr_o <= mem_addr_i;
        end
    end
endmodule


//访存模块
module mem (
    input               clk,
    input               rst,

    //输入
    //写回数据
    input   [`RegAddrBus]       wd_i,
    input                       wreg_i,
    input   [`RegBus]           wdata_i,
    /*从ram得到的数据*/
    input   [`RegBus]           mem_data_i,
    //访存
    input   [`AluOpBus]         aluop_i,
    input   [`RegBus]           mem_addr_i,

    //输出
    //对regfile，rom模块进行相应
    output  reg[`RegAddrBus]    wd_o,
    output  reg                 wreg_o,
    output  reg[`RegBus]        wdata_o,
    output  reg                 test,
    //对ram模块进行访存控制
    output  reg[`RegBus]        mem_addr_o,
    output  reg[`RegBus]        mem_data_o,
    output  reg                 mem_we,
    output  reg[3:0]            mem_sel_o,
    output  reg                 mem_ce_o
);
    initial begin
        test = 1'b0;
    end
    always @(posedge clk) begin
        if(rst == `RstEnable)begin
            wd_o  <= `NOPRegAddr;
            wreg_o <= 1'b0;
            wdata_o <= `ZeroWord;
        end else if(aluop_i == `ALU_LW_OP)begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= mem_data_i;
            mem_addr_o <= mem_addr_i;
            mem_we <= `WriteDisable;
            mem_sel_o <= 4'B1111;
            mem_ce_o <= `ChipEnable;
        end else if(aluop_i == `ALU_SW_OP)begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
            //wdata_o <= mem_data_i;
            //这里将R[reg2]的值作为reg的写会传入了
            mem_data_o <= wdata_i;
            mem_addr_o <= mem_addr_i;
            mem_we <= `WriteEnable;
            mem_sel_o <= 4'B1110;
            mem_ce_o <= `ChipEnable;
        end
        else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
        end
    end
    always @(posedge clk) begin
            test = ~test;
        end
endmodule


//通过这个端口与regfile模块，分别输出we, waddr, wdata端口
module mem_wb (
    input               clk,
    input               rst,

    //输入
    input   [`RegAddrBus]       mem_wd,
    input                       mem_wreg,
    input   [`RegBus]           mem_wdata,


    //输出
    output  reg[`RegAddrBus]    wb_wd,
    output  reg                 wb_wreg,
    output  reg[`RegBus]        wb_wdata
);

always @(posedge clk) begin
    if(rst == `RstEnable)begin
        wb_wd  <= `NOPRegAddr;
        wb_wreg <= 1'b0;
        wb_wdata <= `ZeroWord;
    end else begin
        wb_wd <= mem_wd;
        wb_wreg <= mem_wreg;
        wb_wdata <= mem_wdata;
    end
end
endmodule


module inst_rom(
 
	input   wire			    ce,
	input   wire[`InstAddrBus]	addr,
	output  reg[`InstBus]		inst	
);
       // 定义一个数组，大小是InstMemNum，元素宽度是InstBus,128kb
	reg[`InstBus]  inst_mem[0:`InstMemNum-1];
 
       // 使用文件inst_rom.data初始化指令存储器
	initial $readmemh ( "inst_rom.data", inst_mem );
 
       // 当复位信号无效时，依据输入的地址，给出指令存储器ROM中对应的元素
	always @ (*) begin
	    if (ce == `ChipDisable) begin
	        inst <= `ZeroWord;
	    end else begin
	        inst <= inst_mem[addr[`InstMemNumLog2+1:2]];//addr[18:2]17位
	    end
	end 
endmodule

