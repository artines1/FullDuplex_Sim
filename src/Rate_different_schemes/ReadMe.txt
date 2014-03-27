1. File Description

	a. FDMAC_main_ray_with_channelgain_v3.m - main script
	b. fcn_GetBERFromSINR.m - Calculate Bit Error Rate from SINR (Not use right now)
	c. fcn_GetSINRBoundary.m - Calculate Boundary SINR value for different modulation by given target (Not use right now)
	d. fcn_MAC_CW_UD - Algorithm for FDMAC for Up-Down scenario
	e. fcn_MAC_DU - Algorithm for FDMAC for Down-Up scenario (Not use right now)
	f. fcn_MAC_Power_CW_DU.m - Algorithm for FDMAC for Down-Up scenario, which contains contention of Up stations
	g. fcn_MAC_Power_Fair_DU.m - Algorithm for FDMAC for Down-Up scenario, in which up stations are selected fairly by random (Replaced by fcn_MAC_Power_CW_DU.m)
	h. fcn_MAC_Power_UnFair_DU.m - Algorithm for FDMAC for Down-Up scenario, in which it selects the up station who has the greatest SINR
	i. fcn_MAC_Update_Histroy.m - Function to update history data
	j. fcn_rate_calculate_with_PER.m - calculate rate with Packet Error Rate
