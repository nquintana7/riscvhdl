library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_cpu is
    port (clk, rst : in std_logic;
          instr: in std_logic_vector(31 downto 0);
          memwrite: out std_logic;
          aluresult, writedata : out std_logic_vector(31 downto 0);
          pc: out std_logic_vector(31 downto 0);
          readdata : in std_logic_vector(31 downto 0)    
    );
end riscv_cpu;

architecture behavorial of riscv_cpu is
    component riscv_datapath is
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
    end component;

    component riscv_control is
        port (op: in std_logic_vector(6 downto 0);
              funct3 : in std_logic_vector(14 downto 12);
              funct7: in std_logic;
              zero : in std_logic;
              pcsrc: out std_logic;
            resultsrc: out std_logic_vector(1 downto 0);
            memwrite: out std_logic;
            aluctrl : out std_logic_vector(2 downto 0);
            alusrc : out std_logic;
            immsrc : out std_logic_vector(1 downto 0);
            regwrite : out std_logic;
            jump : out std_logic);
    end component;
    signal alusrc, regwrite, jump, zero, pcsrc : std_logic;
    signal resultsrc, immsrc : std_logic_vector(1 downto 0);
    signal aluctrl : std_logic_vector(2 downto 0);
begin
    CONTROLPATH: riscv_control port map(
        instr(6 downto 0), instr(14 downto 12), instr(30), zero, pcsrc, resultsrc, memwrite, aluctrl, alusrc, immsrc, regwrite, jump
    );

    DATAPATH: riscv_datapath port map(
        clk, rst, pcsrc, alusrc, resultsrc, aluctrl, immsrc, regwrite, instr, readdata, zero, pc, aluresult, writedata
    );
end behavorial;