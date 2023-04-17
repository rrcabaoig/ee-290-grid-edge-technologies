# How does the accuracy of a learning-based AC optimal power flow in a local electricity market vary with different training datasets generated from various PQ models?
### EE 290 Grid-edge Technologies
#### Acronyms
AC: alternating current<br/>
LEM: local electricity market<br/>
OPF: optimal power flow<br/>
PQ: real power P and reactive power Q<br/>
pu: per unit
#### Test system
IEEE 33-bus distribution system by [1] (original case file, `case33bw.m`) and [2] (modified case file, `case33.m`)<br/>
further modification of `case33.m` [2] to `case33rrc.m` to allow bus voltages in the range of 0.90 pu to 1.10 pu
#### Methodology
1. Preparation of $\widehat{x} = \widehat{P_d},\widehat{Q_d}$
2. AC OPF run to solve $\hat{y} = \hat{P_g},\hat{V}$
3. ANN training using $\hat{x},\hat{y}$
4. ANN testing on 
#### References
[1] M. E. Baran and F. F. Wu, "Network reconfiguration in distribution systems for loss reduction and load balancing," in IEEE Transactions on Power Delivery, vol. 4, no. 2, pp. 1401-1407, April 1989, doi: 10.1109/61.25627.<br/>
[2] S. H. Dolatabadi, M. Ghorbanian, P. Siano and N. D. Hatziargyriou, "An Enhanced IEEE 33 Bus Benchmark Test System for Distribution System Studies," in IEEE Transactions on Power Systems, vol. 36, no. 3, pp. 2565-2572, May 2021, doi: 10.1109/TPWRS.2020.3038030.
