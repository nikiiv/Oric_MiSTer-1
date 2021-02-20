  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity tap_loader_TB is

end entity;

architecture sim of tap_loader_TB is

	signal clock 				: std_logic :='1';
	signal reset 				: std_logic :='1';
	signal start_cpu_signal	: std_logic :='0';
	signal stop_cpu_signal	: std_logic :='0';
	signal cpu_rdy_signal	: std_logic :='0';
	
	signal cpu_stopped 		: std_logic := '0';
	
	signal timer 				: integer  :=0;



begin
	dut: entity work.tape_loader
		port map (
		CLK_PHI  	=> clock,
		nRes			=> reset,
		stop_cpu 	=> stop_cpu_signal,
		start_cpu 	=> start_cpu_signal,
		cpu_rdy		=> cpu_rdy_signal,
		cpu_stopped => cpu_stopped
		);

		
	
	clock_gen: process is
	begin
		wait for 10 ns;
		clock <= not clock;
		timer <= timer + 1;
	end process;
	
	gen_reset: process is
		variable reset_done : std_logic := '0';
	begin
		wait until rising_edge(clock);
		if (reset_done = '0' and reset='1') then
			reset <= '0';
			reset_done := '1';
		elsif (reset_done = '1') then
			reset <= '1';
		end if;
	end process;
	
	stop: process(clock)
		variable stop_done : std_logic := '0';
	begin
		if (rising_edge(clock)) then
			report "we are here and timer is " & integer'image(timer) & " clock is " & std_logic'image(clock);
			if (timer > 5) then
				report "=====>>>>>>>>> timer and clock are good " & integer'image(timer);
				if (stop_done = '0') then
					report "INVERTING!!!!!";
					stop_done := '1';
					stop_cpu_signal <= '1';
					report "cpu stopped";
				else
					stop_cpu_signal <= '0';
				end if;
			end if;
		end if;
	end process;
	
	restart: process(clock)
		variable cpu_restarted : std_logic := '0';
	begin
		if rising_edge(clock) then
			if timer > 20 then
				if (cpu_restarted = '0') then
					start_cpu_signal <='1';
					cpu_restarted := '1';
				elsif (start_cpu_signal = '1') then
					start_cpu_signal <= '0';
				end if;
			end if;
		end if;
	end process;

	
	
	

end architecture;

