
t = cell(486,1);
t(:) = str;
for i=1:486
    if i<486
         t(i)= num2str(i) + '.png';
         %%
         filename = fullfile(matlabroot,'Spring Deliverable','StereoImages','left' + t(i));
    end
end