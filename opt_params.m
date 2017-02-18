function [B,C] = opt_params()
B = [0.6032 0.8968 1.0000 0.1746 0.1905 0.5000 0.5079 0.2222 0.2857;     %0to125,level walking
     0.7302 0.7540 1.0000 0.6190 0.5238 0.5000 0.5079 0.2381 0.3175;     %125to0,level walking
     0.4921 0.7540 1.0000 0.4444 0.5238 0.5000 0.5079 0.2222 0.3016;     %125to125,level walking
     0.4286 0.5317 0.4921 0.7619 0.7302 0.6905 0.3810 0.2063 0.3016;     %stairclimbend50,125to0
     0.4921 0.8810 0.4921 0.4286 0.4921 0.6159 0.4286 0.2222 0.2381;     %stairclimbend50,125to125
     0.4762 0.8492 0.4603 0.3968 0.4762 0.5000 0.3968 0.2063 0.2540;     %stairclimbend100,125to125
     0.4127 0.8508 0.6984 0.3651 0.3651 0.5159 0.3968 0.2222 0.2381;     %stairclimbstart50,0to125
     0.4921 0.7698 0.6825 0.3651 0.3333 0.5000 0.3333 0.1587 0.2222;     %stairclimbstart50,125to125
     0.4921 0.4921 0.9841 0.7619 0.5873 0.3968 0.3968 0.1905 0.2540;     %stairdownend50,125to0
     0.5238 0.8095 0.9365 0.2857 0.4603 0.6032 0.3810 0.1905 0.2540;     %stairdownend50,125to125
     0.5397 0.5556 0.9683 0.3651 0.4921 0.4603 0.3810 0.2063 0.2063;     %stairdownend100,125to125
     0.4603 0.5079 0.8730 0.2857 0.2381 0.5079 0.2540 0.1429 0.1905;     %stairdownstart50,0to125
     0.6825 0.4762 0.9048 0.1746 0.2222 0.3651 0.2698 0.1587 0.1905;     %stairdownstart50,125to125 ];
     0.5397 0.4762 0.7937 0.2698 0.4444 0.1905 0.3968 0.2063 0.2381;     %convexrampstart0,125to125
     0.6032 0.5873 0.7210 0.1429 0.3063 0.4159 0.3968 0.1905 0.2698;     %convexrampend0,125to125
     0.3794 0.5559 0.9127 0.3040 0.2857 0.5035 0.4127 0.2063 0.2540;     %convexrampsrtart,0to125
     0.4762 0.5873 0.8349 0.4881 0.4500 0.5000 0.3810 0.1905 0.2698;     %convexrampend,125to0
     0.4921 0.7540 1.0000 0.4444 0.5238 0.5000 0.5079 0.2222 0.3016;     %concaveend125to125
     0.5060 0.7549 1.0000 0.4698 0.5762 0.5097 0.4210 0.2263 0.2957;     %concavestart125to125
     0.7302 0.7540 1.0000 0.6190 0.5238 0.5000 0.5079 0.2381 0.3175;     %concaveend125to0
     0.5730 0.5973 0.9084 0.0794 0.1111 0.5092 0.3316 0.1746 0.2381];    %concavestart0to125
 
%l1 l2 h1 h2 Ncr1 Ncr2
C = [0.000 0.125  0.000  0.000 0 0  0;
     0.125 0.000  0.000  0.000 0 0  0;
     0.125 0.125  0.000  0.000 0 0  0;
     0.000 0.125  0.050  0.000 2 0  0;
     0.125 0.125  0.050  0.000 2 0  0;
     0.125 0.125  0.050  0.050 2 2  0;
     0.000 0.125  0.000  0.050 0 2  0;
     0.125 0.125  0.000  0.050 0 2  0;
     0.125 0.000 -0.050  0.000 2 0  0;
     0.125 0.125 -0.050  0.000 2 0  0;
     0.125 0.125 -0.050 -0.050 2 2  0;
     0.000 0.125  0.000 -0.050 0 2  0;
     0.125 0.125  0.000 -0.050 0 2  0;
     0.125 0.125  0.032  0.003 0 1  1;
     0.125 0.125  0.000  -0.03 1 0  1;
     0.000 0.121  0.000  0.000 0 1  1;
     0.121 0.000  0.000  0.000 1 0  1;
     0.121 0.121  0.000  0.032 1 0 -1;
     0.121 0.121 -0.032  0.000 0 1 -1;
     0.121 0.000  0.000  0.000 1 0 -1;
     0.000 0.121  0.000  0.000 0 1 -1];
 
 
A = [0.6043 0.6984 1.0000 0.3016 0.4921 0.0000 0.4921 0.2063 0.3175;
     0.6043 0.6984 1.0000 0.3016 0.4921 0.0000 0.4921 0.2063 0.3175;
     0.6508 0.6508 0.7778 0.2381 0.4921 0.0476 0.3016 0.1429 0.2540;
     0.4921 0.6825 0.7513 0.3651 0.4762 0.0000 0.3810 0.2063 0.2222;
     0.4921 0.6825 0.7513 0.3651 0.4762 0.0000 0.3810 0.2063 0.2222;
     0.4244 0.7778 0.9024 0.5873 0.6190 0.0159 0.3651 0.1905 0.2222;
     0.7143 0.6984 1.0000 0.3016 0.4921 0.0000 0.4921 0.2063 0.3175;
     0.7143 0.6984 1.0000 0.3016 0.4921 0.0000 0.4921 0.2063 0.3175;
     0.4921 0.5873 0.9524 0.5238 0.8095 0.0317 0.5190 0.2040 0.3010;
     0.6190 0.7619 1.0000 0.3651 0.4603 0.0159 0.3810 0.1905 0.2381;
     0.6508 0.6190 1.0000 0.2381 0.4762 0.0000 0.3968 0.1905 0.2381;
     0.6508 0.6190 1.0000 0.2381 0.4762 0.0000 0.3968 0.1905 0.2381;
     0.6667 0.6984 1.0000 0.3492 0.4762 0.0159 0.3968 0.1905 0.2381;
     0.6349 0.6032 1.0000 0.2381 0.4921 0.0159 0.4286 0.1905 0.3016];   
    
%W = [7.7878 7.7878 4.1619 2.6697 2.6697 3.0896 7.7878 7.7878 5.7277 6.5444 6.4565 6.4565 5.4581 7.3980];
end