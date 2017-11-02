
# Take 3 observations that should not
# stress the system.
def easy_test
  
  # Set A as active capacitor and take observation when ready
  cmd("CFS CFS_WHE_CAP_A_ACTIVE")  
  #wait_check_expression("tlm('CFS CFE_WHE_HKMSG WHE_TEMP') <= 10 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_CHARGE') > 80 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_STATE') == 'CHARGING'",160)
  wait_check_expression("tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_CHARGE') >= 75 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_STATE') == 'CHARGING'",160)
  cmd("CFS CFS_WHE_OBS_START")
  wait(25)
  
  # Set active capacitor to B, wait for it to charge
  #wait(20) # wait for temp to cool.  
  cmd("CFS CFS_WHE_CAP_B_ACTIVE")  
  #wait_check_expression("tlm('CFS CFE_WHE_HKMSG WHE_TEMP') <= 10 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_B_CHARGE') > 80 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_B_STATE') == 'CHARGING'",160)
  wait_check_expression("tlm('CFS CFE_WHE_HKMSG WHE_CAP_B_CHARGE') >= 75 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_B_STATE') == 'CHARGING'",160)
  
  # Start 2nd observation and wait for it to finish.  
  cmd("CFS CFS_WHE_OBS_START")
  wait(20)

  #wait(20)
  # Set active capacitor to A, wait for it to charge
  cmd("CFS CFS_WHE_CAP_A_ACTIVE")  
  #wait_check_expression("tlm('CFS CFE_WHE_HKMSG WHE_TEMP') <= 10 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_CHARGE') > 80 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_STATE') == 'CHARGING'",160)
  wait_check_expression("tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_CHARGE') >= 75 and tlm('CFS CFE_WHE_HKMSG WHE_CAP_A_STATE') == 'CHARGING'",160)
  
  # Start 2nd observation and wait for it to finish.  
  cmd("CFS CFS_WHE_OBS_START")
  wait(20)
  
end

# Attempt to take 3 observations
# that would violate system constraints.
# needs autonomy to manage the capacitor selection
# need autonomy to make sure capacitors don't go too low.
def medium_test
  wait(20) # capture results from the easy test...
  
  5.times do
    cmd("CFS CFS_WHE_OBS_START")
    wait(20)    
  end
end

# Attempt to take 3 observations while
# simultaneously injecting commands
# to handle heaters and louvers manually.
def hard_test
  wait(10) # let some capacitor get up some charge.
  
  5.times do
      wait(5)
      cmd("CFS CFS_WHE_OBS_START")
      wait(5)    
      cmd("CFS CFS_WHE_HTR_ON")
      wait(5)
      cmd("CFS CFS_WHE_LOUVER_CLOSE")
      wait(5)
      
    end
end

# Set up telemetry output
cmd("CFS TO_OUTPUT_ENABLE with CCSDS_CHECKSUM 0, CCSDS_FC 6, CCSDS_LENGTH 17, CCSDS_SEQUENCE 49152, CCSDS_STREAMID 6272, DEST_IP 127.0.0.1") 
wait(3)

cmd("CFS CFS_WHE_POWER_SBC")

# Wait for instrument to power up.
wait(5)
 
#easy_test()

#medium_test()

hard_test()
