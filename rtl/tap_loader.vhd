  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  
 
entity tape_loader is 
generic (
	WAIT_TICKS : integer := 3
);
port (
	CLK_PHI 		: in		std_logic;
	stop_cpu		: in 	std_logic;
	start_cpu	: in 	std_logic;
	cpu_rdy		: out	std_logic;
	nRes			: in		std_logic
--	cpu_stopped : out std_logic
	);
end;

architecture RTL of tape_loader is

	signal cpu_stopped : std_logic := '0';
	signal start_cpu_stopping : std_logic := '0';
	

begin


	process (CLK_PHI, stop_cpu, start_cpu, nRes) is
		--variable we_are_stopping : std_logic := '0';
	begin
	
		if (nRes = '0') then
			cpu_rdy <= '1';
			start_cpu_stopping <= '0';
			--we_are_stopping := '0';
			
		elsif (rising_edge(CLK_PHI)) then
		
			if (start_cpu = '1') then
				cpu_rdy <= '1';
				start_cpu_stopping <= '0';
		
			elsif (stop_cpu = '1') then
				cpu_rdy <= '0';
				start_cpu_stopping <= '1';
			else 
				if (start_cpu_stopping = '0') then
					cpu_rdy <= '1';
					start_cpu_stopping <= '0';
				end if;	
			end if;
			
		end if;
	end process;

	process (CLK_PHI, start_cpu_stopping) is
		variable count_down : integer range WAIT_TICKS downto 0 := WAIT_TICKS;
	begin
		if rising_edge(clk_phI) then 

			if (start_cpu_stopping = '0') then
				count_down := WAIT_TICKS;
				cpu_stopped <= '0';

			elsif (count_down > 0) then
				count_down := count_down - 1;
				if (count_down = 0) then
					cpu_stopped <= '1';
				end if;
			end if;
		end if;
	end process;
	
end architecture;
	
	