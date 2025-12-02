
 % -------- 2.1 ----------------------------
 figs = findall(0, 'Type', 'figure'); %saving figs 
    for k = 1:numel(figs)
        fname = sprintf('2.1_AircraftSim_Fig%d.png', k);
        saveas(figs(k), fname);
    end
    close(figs);

 % -------- 2.2 ----------------------------
 figs = findall(0, 'Type', 'figure'); %saving figs 
    for k = 1:numel(figs)
        fname = sprintf('2.2_AircraftSim_Fig%d.png', k);
        saveas(figs(k), fname);
    end
    close(figs);

 % -------- 2.3 ----------------------------
 figs = findall(0, 'Type', 'figure'); %saving figs 
    for k = 1:numel(figs)
        fname = sprintf('2.3_AircraftSim_Fig%d.png', k);
        saveas(figs(k), fname);
    end
    close(figs);

 % -------- 3.1 ----------------------------
 figs = findall(0, 'Type', 'figure'); %saving figs 
    for k = 1:numel(figs)
        fname = sprintf('3.1_DoubletSim_Fig%d.png', k);
        saveas(figs(k), fname);
    end
    close(figs);

 % -------- 3.2 ----------------------------
 figs = findall(0, 'Type', 'figure'); %saving figs 
    for k = 1:numel(figs)
        fname = sprintf('3.2_DoubletSim_Fig%d.png', k);
        saveas(figs(k), fname);
    end
    close(figs);
