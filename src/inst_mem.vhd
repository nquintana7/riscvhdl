library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- For now the instruction memory is separated from data and treated as a ROM   
-- Later I will unify them and implement the interfacing with the DDR3 RAM provided in my fpga board.

entity riscv_instmem is
    port (a: in std_logic_vector(31 downto 0);
          rd: out std_logic_vector(31 downto 0));
end riscv_instmem;

architecture behavorial of riscv_instmem is
    type ramtype is array(63 downto 0) of std_logic_vector(31 downto 0);
    impure function init_ram_hex return ramtype is
        file text_file : text open read_mode is "riscvtest.txt";
        variable text_line : line;
        variable ram_content : ramtype;
        variable i : integer := 0;
        begin
            for i in 0 to 63 loop
                ram_content(i) := (others => '0');
            end loop;

            while not endfile(text_file) loop
                readline(text_file, text_line);
                hread(text_line, ram_content(i));
                i := i + 1;
            end loop;

            return ram_content;
    end function;
        signal rom : ramtype := init_ram_hex;
        begin
            process(a) begin
                rd <= rom(to_integer(unsigned(a(31 downto 2))));
            end process;
end behavorial;