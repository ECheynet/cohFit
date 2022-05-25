# cohFit
A set of Matlab functions to fit the co-coherence of turbulence with empirical models.

## Summary

The Matlab function cohFit uses a least-square fit approach to fit an empirical co-coherence model to the one estimated from measurements. It should be applied either to pure lateral, vertical or longitudinal spatial separation to reduce the propagation of uncertainties and the risk of overfitting. In the present version, three empirical models are used: the Davenport model [2], the Bown model [3] and the modified Bowen model [1]. These three models can be applied for wind load modelling for structural design, e.g. Wind turbines, high rise buildings or long-span bridges. The present routines have been applied in ref [1], but also refs [4,5,6] among others. This is the first version of the repository. Some bugs may still be present. Feel free to contact me if you have any question.

## Content

The present repository contains:
  - a .mat file timeSeries.ma tused in the documentation
  - A Matlab livescript Documentation.mlx
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
