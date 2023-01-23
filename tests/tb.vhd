library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end;

architecture test of testbench is
    component riscvTop
        port(clk, rst: in STD_LOGIC;
            writedata: out STD_LOGIC_VECTOR(31 downto 0);
            dataaddr: out STD_LOGIC_VECTOR(31 downto 0);
            mw: out STD_LOGIC);
end component;
    signal writedata, dataaddr: STD_LOGIC_VECTOR(31 downto 0);
    signal clk, rst, mw: STD_LOGIC := '0';
begin

dut: riscvTop port map(clk, rst, writedata, dataaddr, mw);

process begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
end process;

process begin
    rst <= '1';
wait for 22 ns;
    rst <= '0';
wait;
end process;

process(clk) 
begin
    if(falling_edge(clk) and mw = '1') then
        if(to_integer(unsigned(dataaddr)) = 100 and to_integer(unsigned(writedata)) = 25) then
            report "NO ERRORS: Simulation succeeded" severity failure;   
        elsif (to_integer(unsigned(dataaddr)) /= 96) then
            report "Simulation failed" severity failure;
        end if;     
    end if;
end process;
end;