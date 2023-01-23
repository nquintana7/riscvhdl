library IEEE;
use IEEE.STD_LOGIC_1164.all;
    entity riscvTop is
    port(clk, rst: in STD_LOGIC;
        sw : in std_logic;
        serial_tx: out std_logic);
    end;
architecture test of riscvTop is

    component riscv_cpu
        port(clk, rst: in STD_LOGIC;
            pc: out STD_LOGIC_VECTOR(31 downto 0);
            instr: in STD_LOGIC_VECTOR(31 downto 0);
            memwrite: out STD_LOGIC;
            aluresult, writedata: out STD_LOGIC_VECTOR(31 downto 0);
            readdata: in STD_LOGIC_VECTOR(31 downto 0));
        end component;

    component riscv_instmem
        port(a: in STD_LOGIC_VECTOR(31 downto 0);
            rd: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component riscv_datamem
        port(clk, we: in STD_LOGIC;
            a, wd: in STD_LOGIC_VECTOR(31 downto 0);
            rd: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component baudclk is
        GENERIC(clk_frequency: integer := 100e6; -- in Hz
                baudrate : integer := 115200);
        PORT(clk: in std_logic;
             rst: in std_logic;
             bclk: out std_logic;
             b16clk: out std_logic);
    end component;
    
    component uart_tx is
        port(clk: in std_logic;
            bclk : in std_logic;
            rst: in std_logic;
            enable: in std_logic;
            data: in std_logic_vector(7 downto 0);
            busy: out std_logic;
            serial_line: out std_logic);
    end component;

    signal pc, instr, readdata: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal tmpwritedata, tmpdataaddr : std_logic_vector(31 downto 0);
    signal tmpmemwrite : std_logic; 
    signal bclk, b16clk, tx_busy : std_logic := '0';

    signal tx_enable : std_logic := '0';
begin
    B_CLK: baudclk port map(
        clk => clk,
        rst => rst,
        bclk => bclk,
        b16clk => b16clk
    );
    
    TX: uart_tx  port map(
                    clk => clk,
                    bclk => bclk,
                    rst => rst,
                    enable => tx_enable,
                    data => tmpwritedata(7 downto 0),
                    busy => tx_busy,
                    serial_line => serial_tx
                );  

    rvsingle: riscv_cpu port map(clk, rst, pc, instr,
            tmpmemwrite, tmpdataaddr,
            tmpwritedata, readdata);

    instmem: riscv_instmem port map(pc, instr);

    datamem: riscv_datamem port map(clk, tmpmemwrite, tmpdataaddr, tmpwritedata, readdata);
    process(clk)
    begin
        if sw = '1' then
            tx_enable <= '1';
        else 
            tx_enable <= '0';
        end if;
    end process;
end;