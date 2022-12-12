# Fitting the co-coherence of turbulence

[![DOI](https://zenodo.org/badge/496147545.svg)](https://zenodo.org/badge/latestdoi/496147545)
[![View Fitting the co-coherence of turbulence on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/112180-fitting-the-co-coherence-of-turbulence)
[![Donation](https://camo.githubusercontent.com/a37ab2f2f19af23730565736fb8621eea275aad02f649c8f96959f78388edf45/68747470733a2f2f77617265686f7573652d63616d6f2e636d68312e707366686f737465642e6f72672f316339333962613132323739393662383762623033636630323963313438323165616239616439312f3638373437343730373333613266326636393664363732653733363836393635366336343733326536393666326636323631363436373635326634343666366536313734363532643432373537393235333233303664363532353332333036313235333233303633366636363636363536353264373936353663366336663737363737323635363536653265373337363637)](https://www.buymeacoffee.com/echeynet)

## Summary

The Matlab function cohFit uses a least-square fit approach to fit an empirical co-coherence model to the one estimated from measurements. It considers multiple distances and frequencies at the same time, so it is a surface fit. It should be applied either to pure lateral, vertical or longitudinal spatial separation to reduce the propagation of uncertainties and the risk of overfitting. In the present version, three empirical models are used: the Davenport model [2], the so-called Bowen model [3] and the modified Bowen model [1]. These three models can be applied for wind load modelling on structures, e.g. Wind turbines, high-rise buildings or long-span bridges. The present routines have been applied in ref [1] but also refs [4,5,6] among others. This is the first version of the repository. Some bugs may still be present. Feel free to contact me if you have any questions.

## Content

The present repository contains:
  - a .mat file timeSeries.ma tused in the documentation
  - A Matlab LiveScript Documentation.mlx
  - The function coherence.m is used to estimate the co-coherence and quad-coherence of turbulence
  - The function label to write some text in subpanels
  - The function targetCoh.m, which is only used in the documentation for the idealized cases
  - The function getDistance.m, which is necessary to compute the distance between measurement locations and their respective indices
  - The function cohFit.m, which is the main function to fit the empirical co-coherence model to the estimated co-coherence.

## References

[1] Cheynet, Etienne. "Influence of the measurement height on the vertical coherence of natural wind." Conference of the Italian Association for Wind Engineering. Springer, Cham, 2018.

[2] Davenport, Alan G. "The response of slender, line-like structures to a gusty wind." Proceedings of the Institution of Civil Engineers 23.3 (1962): 389-408.

[3] Bowen, A. J., R. G. J. Flay, and H. A. Panofsky. "Vertical coherence and phase delay between wind components  in strong winds below 20 m." Boundary-Layer Meteorology 26.4 (1983): 313-324.

[4] Cheynet, Etienne, Jasna B. Jakobsen, and Joachim Reuder. "Velocity  spectra and coherence estimates in the marine atmospheric boundary  layer." Boundary-layer meteorology 169.3 (2018): 429-460.

[5] Cheynet, Etienne, et al. "The COTUR project: remote sensing of offshore turbulence for wind energy application." Atmospheric Measurement Techniques 14.9 (2021): 6137-6157.

[6] Midjiyawa, Zakari, et al. "Potential  and challenges of wind measurements using met-masts in complex  topography for bridge design: Part II–Spectral flow characteristics." Journal of Wind Engineering and Industrial Aerodynamics 211 (2021): 104585.
