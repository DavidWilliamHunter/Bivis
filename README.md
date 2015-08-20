# Bivis

Source code released in connection with the following papers:

Hunter, D. W., & Hibbard, P. B. (Accepted 2015). Distribution of independent components of binocular natural images. Journal of Vision. 
Code associated with Hunter and Hibbard (JOV 2015) is found in the folder ‘Phase_Position_Disparity_ICA\src’
Code is divided amongst 4 folders.
\Phase_Position_Disparity_ICA\src\accuracy\  - Code to verify the accuracy of the Gabor fitting process
\Phase_Position_Disparity_ICA\src\calculateICA\ - Code to generate ICA components, fit Gabor functions, analyse the Gabor distributions and display the results.
Suggested Order:
calculateICAcomponents.m – generate ICA components from binocular image set, fit Gabor functions and save the data. May need user input to specify directories.
calculateRandomICAcomponents.m – generate ICA component from binocular image set left and right pairs jumbled to break any link between left and right image.
fillInNaNs.m – Not all Gabor fits work first time, give the fitting process another go.
computeFullICA.m – Load and format ICA data (may need to specify directories)
plotJOVDouble_EPS – generate Plots for JOV 2015 paper.
\Phase_Position_Disparity_ICA\src\calculateScale – Code to generate ICA components at various scales, fit Gabor functions, analyse the Gabor distributions and display the results.
Suggested Order:
computeScaleICA.m – calculate ICA components for binocular images over a range of scales.
plotScaleComparisions.m – Load and process Gabor data from computeScaleICA, scaled in pixels.
plotScaleComparisionArcMinutes.m - Load and process Gabor data from computeScaleICA, scaled in ArcMinutes.
thePlottingBit.m – Produce plots formatted for JOV

\Phase_Position_Disparity_ICA\src\util – Useful utilities.
General code shared between this and future papers is found in the directory and subdirectories of 
\common\
The dataset from (Hibbard, 2007) is found in
\common\images\
Third party software:
The code requires two third party libraries, FastICA by Hyvärinen (http://research.ics.aalto.fi/ica/fastica/) and CircStat by Berens

CircStat for Matlab 
=======================
Toolbox for circular statistics with Matlab.
Authors: Philipp Berens 
Email: philipp@bethgelab.org 
Homepage: http://philippberens.wordpress.com/code/circstats/
Contributors: 
Marc Velasco, Tal Krasovsky
Reference: 
P. Berens, CircStat: A Matlab Toolbox for Circular Statistics, Journal of Statistical Software, Volume 31, Issue 10, 2009 
http://www.jstatsoft.org/v31/i10


Hibbard, P. B. (2007). A statistical model of binocular disparity. Visual Cognition, 15(2), 149-165. 



