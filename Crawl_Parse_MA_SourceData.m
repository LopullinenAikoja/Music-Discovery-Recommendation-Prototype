while (nn<height(c))
try for nn = n3:height(c)
        nn
        cnum = num2str(c.id(nn))
    c.band(nn)
    u = strcat('https://www.metal-archives.com/band/discography/id/',cnum,'/tab/all');
    d = urlread(u);
    ds = strsplit(d,strcat('https://www.metal-archives.com/band/discography/id/',cnum,'/tab/all'));
    ds2 = strsplit(d,'<td><a href="');
    e = strfind(ds2{2},'/');
    burl = strcat('https://www.metal-archives.com/bands',ds2{2}(e(4):e(5)),cnum,'#band_tab_members_all');
    b = cell(1);
    for m = 2:length(ds2)
        a = strsplit(ds2{m},'" class=');
        b{m} = a{1};
    end
    if(isempty(b))
        c(nn,:) = [];
        cnum = num2str(c.id(nn))
        c.band(nn)
        u = strcat('https://www.metal-archives.com/band/discography/id/',cnum,'/tab/all');
        d = urlread(u);
        ds = strsplit(d,strcat('https://www.metal-archives.com/band/discography/id/',cnum,'/tab/all'));
        ds2 = strsplit(d,'<td><a href="');
        e = strfind(ds2{2},'/');
        burl = strcat('https://www.metal-archives.com/bands',ds2{2}(e(4):e(5)),cnum,'#band_tab_members_all');
        b = cell(1);
        for m = 2:length(ds2)
            a = strsplit(ds2{m},'" class=');
            b{m} = a{1};
        end
    end
        v = cell(0);
        t = cell(0);
    for m = 2:numel(b)
        u = b{m};
        d = urlread(u);
        s1 = strfind(d,'<div id="album_all_members_lineup">');
        s2 = strfind(d,'<div id="album_members_lineup">');
        if(~isempty(s1))
            d = d(s1:s2);
            d = strsplit(d,'<td width="300" valign="top">');
        else
            s3 = strfind(d,'<div id="album_tabs_reviews" class="ui-tabs-hide">');
            d = d(s2:s3);
            d = strsplit(d,'<td width="300" valign="top">');
        end
        if(numel(d)<=1)
            d = urlread(burl);
            s1 = strfind(d,'<div id="band_tab_members_current">');
            s2 = strfind(d,'<div id="auditTrail">');
            d = d(s1:s2);
            d = strsplit(d,'<td width="200" valign="top">');
        end 
        t = cell(0);
        for n = 2:numel(d)-1
            c3 = strsplit(d{n},'">');
            c3 = strsplit(c3{2},'</a>');
            c3{1}
            c4 = strsplit(d{n},'">');
            c4 = strsplit(c4{2},'<td>');
            c4 = strsplit(c4{2},'</td>');
            c4 = c4{1};
            c3{2} = c4    ;
            c2 = strsplit(d{n},'">');
            c2 = strsplit(c2{1},'"');
            c2 = c2{2};
            c3{3} = c2;
            t(n-1,1:3) = c3;
            astring = b{m};
            albs = strfind(astring,'/');
            slash = albs(5);
            slashslash = albs(6);
            t{n-1,4} = astring(slash+1:slashslash-1);
        end
        [l1,w1] = size(v);
        l1 = l1;
        [l2,w2] = size(t);
        l2 = l1+l2;
        l1 = l1+1;
        v(l1:l2,1:4) = t;    
    end
    [a,a1] = unique(v(:,1));
    ub = cell(1);
    ub = v(a1,1:4);
    [ubl,ubw] = size(ub);
    a3 = cell(1);
    a4 = cell(1);
    for m = 1:ubl
        m = m
        an = ub{m,1}
        d = urlread(ub{m,3});
        a = strfind(d,'<h3 class="member_in_band_name">');
        d = d(a(1):length(d));
        dd = strsplit(d,'band_tab_members" title="');
        for n = 2:numel(dd)
            a2 = strsplit(dd{n},'">');
            a3{m,n-1} = a2{1};
            try a2 = strsplit(dd{n},'<strong>');
                a2 = strsplit(a2{2},'</strong>');
                a4{m,n-1} = a2{1};
            catch
                a2 = strsplit(dd{n},'<td>');
                a2 = strsplit(a2{2},'</td>');
                a4{m,n-1} = a2{1};
            end
        end
    end
    [l,w] = size(a3);
    a3(1:l,w+1) = cell(l,1);
    cat = cell(1);
    for n = 1:l
        for m = 1:w+1
            if isempty(a3{n,m})
                cat{n} = categorical(a3(n,1:(m-1)));
                break
            end
        end
    end
    cats = categorical;
    for n = 1:length(cat)
        l1 = length(cats);
        l2 = length(cat{n});
        cats(l1+1:(l1+l2)) = categorical(cat{n});
    end
    [a,a1] = unique(cats);
    a = a.';
    a = cellstr(a);
    ptable.id(nn) = c.id(nn);
    ptable.bands{nn} = a;
    ptable.band(nn) = c.band(nn);
    ptable.members{nn} = categorical(ub(:,1));
    ptable.member_url{nn} = categorical(ub(:,3))

% Garbage collection!!!

    cats=[];cats1=[];
    cat=[];cat1=[];catsi=[];
    a=[];a1=[];a2=[];a3=[];a4=[];
    b=[];d=[];dd=[];ds=[];ds2=[];c3=[];c4=[];
    ub=[];l1=0;l2=0;
    if(mod(nn/10,1)==0)
        save('build.mat','ptable','c')
    end
    end
catch
c(nn,:) = [];
n3 = nn;
end
end


