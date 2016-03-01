function uninstallTraining
rootDir = fileparts(mfilename('fullpath'));
rmpath(rootDir);
savepath