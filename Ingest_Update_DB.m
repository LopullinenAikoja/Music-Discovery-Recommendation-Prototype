% Load Database files, reference data, and incoming data

load('Ptable.mat')
ptable_save = ptable;
pjoin_save = pjoin;
load('Atable.mat')
uiopen('C:\Users\Rowan\Desktop\Albums_Updated_12142019.csv',1)
uiopen('C:\Users\Rowan\Desktop\AllBands_12142019.csv',1)
load('C:\Users\Rowan\Desktop\build.mat')

% Ensure compatable data types for key fields
Bands.band = cellstr(Bands.band);
Bands.genre = cellstr(Bands.genre);
Bands.country = categorical(Bands.country);
Bands.label = cellstr(Bands.label);
Albums.band = cellstr(Albums.band);
Albums.genre = cellstr(Albums.genre);
Albums.label = cellstr(Albums.label);
Albums = sortrows(Albums,5,'descend');

% Join data fields from bands database and calculate basic figures
[c2,ia,ib] = intersect(ptable.id,Bands.id,'stable')
c2 = Bands(ib,:)
[ia,ib] = unique(ptable.id);
ptable = ptable(ib,:);
for n = 1:height(ptable)
ptable.total_b(n) = numel(ptable.bands{n});
ptable.total_m(n) = numel(ptable.members{n});
end
for n = 1:height(ptable)
ptable.genre(n) = cellstr(c2.genre(n));
ptable.label(n) = cellstr(c2.label(n));
end

% Join data from albums database & add update to DB table
[c3,ia,ib] = intersect(ptable.id,Albums.id,'stable')
for n = 1:length(ia)
    y = Albums.year(ib(n));
    ptable.year(ia(n)) = y;
end
ptable.sincelast = 2020-ptable.year;
ptable.yearformed = c2.yearformed;
% ptable_save(height(ptable_save)+1:height(ptable)+height(ptable_save),:) = ptable;

% Join data from master table
[c2,ia,ib] = intersect(ptable.id,A.id,'stable')
c2 = A(ib,:);
pjoin = ptable(ia,:);
pjoin(:,13:21) = c2(:,3:11)
pjoin.Var19 = []
pjoin.Properties.VariableNames{13} = 'city';
pjoin.Properties.VariableNames{14} = 'country';
pjoin.Properties.VariableNames{15} = 'active';
pjoin.Properties.VariableNames{17} = 'core_members';
pjoin.Properties.VariableNames{18} = 'discography';
pjoin.Properties.VariableNames{19} = 'corenum';
pjoin.Properties.VariableNames{20} = 'discnum';
pjoin.genre = pjoin.Var16;
% Calculate some stats
valueset = {'Full-length' 'Single' 'EP' 'Compilation' 'Split' 'Boxed set' 'Video' 'Demo'};
for n = 1:height(pjoin)
    pjoin.core_ratio(n) = pjoin.total_m(n)/pjoin.corenum(n);    
%    pjoin.mcr(n) = pjoin.core_ratio(n)*pjoin.mpera(n);
    if ~isempty(pjoin.discography{n})
        BC = categorical(pjoin.discography{n}(2,:),valueset);
        cc = countcats(BC);
        pjoin.flalbums(n) = cc(1);
        pjoin.mpera(n) = pjoin.total_m(n)/pjoin.flalbums(n);
        if isinf(pjoin.mpera(n))
            pjoin.mpera(n) = pjoin.corenum(n);
        end       
        if isnan(pjoin.mpera(n))
            pjoin.mpera(n) = pjoin.corenum(n);
        end  
    end
end

% Fill in any missing data from master table

for n = 1:height(pjoin)
    if isempty(pjoin.members{n})
        pjoin.total_m(n) = pjoin.corenum(n);
        try pjoin.members{n} = pjoin.core_members{n}(2,:).';
        end
        pjoin.members{n} = categorical(pjoin.members{n});
    else
        pjoin.total_m(n) = numel(pjoin.members{n});  
    end
    pjoin.total_b(n) = numel(pjoin.bands{n});
end

    % If bannd had only one release, check to see whether it was a
    % full-length release, an EP, or a demo. Bands whose sole release was a
    % demo are eliminated. If only an EP, reduced by half. 

for n = 1:height(pjoin)
    try if(pjoin.discnum(n)==1)
        if(strcmp(pjoin.discography{n}(2),'EP')==1)
            pjoin.alfac(n) = .5;
        end
        if(strcmp(pjoin.discography{n}(2),'Demo')==1)
            pjoin.alfac(n) = 0;
        end
        if(strcmp(pjoin.discography{n}(2),'Full-length')==1)
            pjoin.alfac(n) = 1;
        end
        end
        if(pjoin.discnum(n)>1)
           pjoin.alfac(n) = 1;
        end
    catch
        pjoin.alfac(n) = 1;
    end
end

 % generate factors and figures for band status, length of career, and
 % average rate of output over time.
 
 % Defunct and inactive bands are diminished outright, and by duration of
 % inactivity. Potentially offset by intensity of active career. 
 
for n = 1:height(pjoin)
    if(strcmp(pjoin.active{n},'Split-up')==1)
        pjoin.acfac(n) = .5;
        pjoin.longevity(n) = pjoin.year(n)-pjoin.yearformed(n);
        if(pjoin.longevity(n)~=0) 
            pjoin.dpy(n) = pjoin.discnum(n)/(pjoin.year(n)-pjoin.yearformed(n));
        else
            pjoin.dpy(n) = pjoin.discnum(n);
        end
    end
    if(strcmp(pjoin.active{n},'On hold')==1)
        pjoin.acfac(n) = .75;
        pjoin.longevity(n) = pjoin.year(n)-pjoin.yearformed(n);
        if(pjoin.longevity(n)~=0) 
            pjoin.dpy(n) = pjoin.discnum(n)/(pjoin.year(n)-pjoin.yearformed(n));
        else
            pjoin.dpy(n) = pjoin.discnum(n);
        end
    end
    if(strcmp(pjoin.active{n},'Unknown')==1)
        pjoin.acfac(n) = .5;
        pjoin.longevity(n) = pjoin.year(n)-pjoin.yearformed(n);
        if(pjoin.longevity(n)~=0) 
            pjoin.dpy(n) = pjoin.discnum(n)/(pjoin.year(n)-pjoin.yearformed(n));
        else
            pjoin.dpy(n) = pjoin.discnum(n);
        end
    end
    if(strcmp(pjoin.active{n},'Changed name')==1)
        pjoin.acfac(n) = .5;
        pjoin.longevity(n) = pjoin.year(n)-pjoin.yearformed(n);
        if(pjoin.longevity(n)~=0) 
            pjoin.dpy(n) = pjoin.discnum(n)/(pjoin.year(n)-pjoin.yearformed(n));
        else
            pjoin.dpy(n) = pjoin.discnum(n);
        end
    end
    if(strcmp(pjoin.active{n},'Active')==1)
        pjoin.acfac(n) = 1;
        pjoin.longevity(n) = 2020-pjoin.yearformed(n);
        pjoin.dpy(n) = pjoin.discnum(n)/(pjoin.longevity(n));
    end
end

pjoin.instruments = c2.instruments;
pjoin.numinst = c2.numinst;
pjoin.stemInst = c2.stemInst;
for n = 1:height(pjoin)
    pjoin.menudisp{n} = strcat(pjoin.band{n},'   -   ',pjoin.genre{n},'   -   ',pjoin.country{n});
    pjoin.menudisp(n) = cellstr(pjoin.menudisp{n});
end
% Update joined and processed table
pjoin.band = cellstr(pjoin.band);
pjoin_save(height(pjoin_save)+1:height(pjoin)+height(pjoin_save),:) = pjoin;
ptable_save = pjoin_save(:,1:12);

%continue/conclude
ptable = ptable_save;
pjoin = pjoin_save;






