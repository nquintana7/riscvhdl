library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_signed.all;

entity riscv_datapath is
    port (
        clk : in std_logic;
        rst: in std_logic;
        pcsrc, alusrc: in std_logic;
        resultsrc: in std_logic_vector(1 downto 0);
        aluctrl : in std_logic_vector(2 downto 0);
        immsrc : in std_logic_vector(1 downto 0);
        regwrite : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        readdata: in std_logic_vector(31 downto 0);
        zero : out std_logic;
        pc : out std_logic_vector(31 downto 0);
        aluresult, writedata : out std_logic_vector(31 downto 0)
    );
end riscv_datapath;

architecture behavorial of riscv_datapath is
    component riscv_regs is
        port (
            clk : in std_logic;
            we: in std_logic;
            a1, a2, a3: in std_logic_vector(4 downto 0);
            d3: in std_logic_vector(31 downto 0);
            r1, r2: out std_logic_vector(31 downto 0)
        );
    end component;

    component riscv_extend is
        port (inst: in std_logic_vector(31 downto 7);
            ex_imm: out std_logic_vector(31 downto 0);
            src : in std_logic_vector(1 downto 0)
    );
    end component;

    component riscv_alu is
        port (
            srcA: in std_logic_vector(31 downto 0);
            srcB: in std_logic_vector(31 downto 0);
            op: in std_logic_vector(2 downto 0);
            result: out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
    end component;    

    component flopr is
        port(clk, reset: in STD_LOGIC;
        d:
        in STD_LOGIC_VECTOR(31 downto 0);
        q:
        out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component riscv_datamem is
        port (
            clk : in std_logic;
            we: in std_logic;
            a, wd: in std_logic_vector(31 downto 0);
            rd: out std_logic_vector(31 downto 0)
        );
    end component;

    signal rfile_r1: std_logic_vector(31 downto 0);
    signal rfile_r2: std_logic_vector(31 downto 0);
    signal ex_output : std_logic_vector(31 downto 0);
    signal alu_result: std_logic_vector(31 downto 0);
    
    signal tmp_pc : std_logic_vector(31 downto 0);
    signal pc_add4 : std_logic_vector(31 downto 0);
    signal pc_target : std_logic_vector(31 downto 0);
    signal pc_next : std_logic_vector(31 downto 0);


    signal mux_nextPc : std_logic_vector(31 downto 0);
    signal mux_srcB : std_logic_vector(31 downto 0);
    signal mux_resultSrc : std_logic_vector(31 downto 0);
begin
    pc <= tmp_pc;
    pcreg: flopr port map(clk, rst, mux_nextPc, tmp_pc);

    pc_add4 <= tmp_pc + 4;

    mux_nextPc <= pc_target when pcsrc = '1' else
                  pc_add4;

    pc_target <= ex_output + tmp_pc;

    writedata <= rfile_r2;

    mux_srcB <= ex_output when alusrc = '1' else
                rfile_r2;

    mux_resultSrc <= alu_result when resultsrc = "00" else
                     readdata when resultsrc = "01" else
                     pc_add4;
    
    reg_file : riscv_regs port map(
        clk => clk,
        we => regwrite,
        a1 => inst(19 downto 15),
        a2 => inst(24 downto 20),
        a3 => inst(11 downto 7),
        d3 => mux_resultSrc,
        r1 => rfile_r1,
        r2 => rfile_r2
    );

    extend_unit : riscv_extend port map(
        inst => inst(31 downto 7),
        src => immsrc,
        ex_imm => ex_output
    );

    ALU: riscv_alu port map(
        srcA => rfile_r1,
        srcB => mux_srcB,
        op => aluctrl,
        result => alu_result,
        zero => zero
    );

    aluresult <= alu_result;
end behavorial;