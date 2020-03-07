% Calculate Social Sets & Intersections

modes = {'Basic', 'Basic + Member Output','Basic + Instrument Matching','Basic + Instrument Matching + Member Output','Basic/Fast', 'Full','Full + Member Output', 'Full  + Instrument Matching','Full + Instrument Matching + Member Output','Expanded'};
mmode = listdlg('PromptString', 'Select Runtime Mode',...
            'SelectionMode','single',... 
            'ListSize',[320,600],...
            'ListString',modes);
switch mmode
    case 1
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'SelectionMode','single',... 
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms};
        m = ms;         
        ofn1 = pjoin.band{m};
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));        
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);       
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
        end
        PNM = PNM.';
        PNB = PNB.';
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);    
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2);
            T.S(n) = T.S2(n)*pjoin.acfac(n);
            T.S(n) = T.S2(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*(T.Var7(n)+T.Var8(n)+T.Var9(n))/3;
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
        end
        T = sortrows(T,10,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:12);
        T(n:end,:) = [];
        T2 = sortrows(T2,12,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = []; 
        ofn = strcat(ofn1,'.csv');
        ofn2 = strcat(ofn1,'_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 2
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'SelectionMode','single',... 
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms};
        m = ms;         
        ofn1 = pjoin.band{m};
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));        
        mnames = cell(height(pjoin),1);
        murls = cell(height(pjoin),1);
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);       
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            [murls{n},j] = intersect(M{n},M{m});
            mnames{n} = MN{n}(j);
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
        end
        PNM = PNM.';
        PNB = PNB.';
        TM = table(pjoin.id,mnames,murls);
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);      
        TM = sortrows(TM,1);
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2);
            T.S(n) = T.S2(n)*pjoin.acfac(n);
            T.S(n) = T.S2(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*(T.Var7(n)+T.Var8(n)+T.Var9(n))/3;
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var7(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
            T.M{n} = TM{n,2};
            T.MU{n} = TM{n,3};
        end
        T = sortrows(T,10,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:14);
        T(n:end,:) = [];
        T2 = sortrows(T2,12,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = []; 
        ofn = strcat(ofn1,'.csv');
        ofn2 = strcat(ofn1,'_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 3
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;       
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'SelectionMode','single',... 
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms};
        m = ms;
        ofn1 = pjoin.band{m};
        I_Select = pjoin.stemInst{m};
        I = pjoin.stemInst(1:height(pjoin)); 
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        PNI = double(height(pjoin));
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);      
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
            if (numel(I{n})~=0)
                In = I{n};
                II = intersect(I_Select,In);
                PNI(n) = numel(II)/numel(I_Select);
            else
                PNI(n) = 0;
            end            
        end
        PNM = PNM.';
        PNB = PNB.';
        PNI = PNI.';
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL,PNI);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);        
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);  
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end        
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var10(n);
            T.S(n) = T.S(n)*pjoin.acfac(n);
            T.S(n) = T.S(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n)+T.Var9(n))/3)*T.Var10(n);
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S3(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var9(n)*T.Var10(n);
            T.S3(n) = T.S3(n)*pjoin.acfac(n);
            T.S3(n) = T.S3(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
        end
        T = sortrows(T,12,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:14);
        T(n:end,:) = [];        
        T2 = sortrows(T2,14,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = [];
        ofn = strcat(ofn1,'.csv');
        ofn2 = strcat(ofn1,'_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 4
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;       
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'SelectionMode','single',... 
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms};
        m = ms;         
        ofn1 = pjoin.band{m};
        I_Select = pjoin.stemInst{m};
        I = pjoin.stemInst(1:height(pjoin)); 
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        PNI = double(height(pjoin));
        mnames = cell(height(pjoin),1);
        murls = cell(height(pjoin),1);
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);      
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            [murls{n},j] = intersect(M{n},M{m});
            mnames{n} = MN{n}(j);
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
            if (numel(I{n})~=0)
                In = I{n};
                II = intersect(I_Select,In);
                PNI(n) = numel(II)/numel(I_Select);
            else
                PNI(n) = 0;
            end            
        end
        PNM = PNM.';
        PNB = PNB.';
        PNI = PNI.';
        TM = table(pjoin.id,mnames,murls);
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL,PNI);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);        
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);  
        TM = sortrows(TM,1);
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end        
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var10(n);
            T.S(n) = T.S(n)*pjoin.acfac(n);
            T.S(n) = T.S(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n)+T.Var9(n))/3)*T.Var10(n);
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S3(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var9(n)*T.Var10(n);
            T.S3(n) = T.S3(n)*pjoin.acfac(n);
            T.S3(n) = T.S3(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
            T.M{n} = TM{n,2};
            T.MU{n} = TM{n,3};            
        end
        T = sortrows(T,12,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:16);
        T(n:end,:) = [];
        T2 = sortrows(T2,14,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = [];
        ofn = strcat(ofn1,'.csv');
        ofn2 = strcat(ofn1,'_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 5
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'SelectionMode','single',...
        	'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms};
        m = ms;
        ofn1 = pjoin.band{m};
        I_Select = pjoin.stemInst{m};
        I = pjoin.stemInst(1:height(pjoin));
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        PNI = double(height(pjoin));
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
            if (numel(I{n})~=0)
                In = I{n};
                II = intersect(I_Select,In);
                PNI(n) = numel(II)/numel(I_Select);
            else
                PNI(n) = 0;
            end
        end
        PNM = PNM.';
        PNB = PNB.';
        PNI = PNI.';
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL,PNI,pjoin.acfac,pjoin.alfac);
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        for n = 1:height(T)
            if (T.Var6{n}==0)
                break
            end
        end
        TH = n;
        for n = 1:TH
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
            if(T.Var6{n}==0)
                T.Var8(n)=0;
             end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var10(n);
            T.S(n) = T.S(n)*T.Var11(n);
            T.S(n) = T.S(n)*T.Var12(n);
            T.S2(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n)+T.Var9(n))/3)*T.Var10(n);
            T.S2(n) = T.S2(n)*T.Var11(n);
            T.S2(n) = T.S2(n)*T.Var12(n);
            T.S3(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var9(n)*T.Var10(n);
            T.S3(n) = T.S3(n)*T.Var11(n);
            T.S3(n) = T.S3(n)*T.Var12(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*T.Var11(n);
            T.S4(n) = T.S4(n)*T.Var12(n);
            S5(n) = (T.Var6{n}+T.Var7(n))/2;
            T.S4(n) = (T.S4(n)+S5(n))/2;
        end
        T = sortrows(T,14,'descend');
        T(TH:end,:) = [];
        ofn = strcat(ofn1,'.csv');
        writetable(T,ofn);
    case 6
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;        
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms(1)};
        nb(1) = pjoin.total_b(ms(1));
        if (numel(ms)>1)
            for m = 2:numel(ms)
                SM = union(SM,pjoin.member_url{ms(m)});
                nb(m) = pjoin.total_b(ms(m));
            end
        end
        [mbm,i] = max(nb);
        m = ms(i);
        ofn1 = pjoin.band{m};
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);          
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
        end
        PNM = PNM.';
        PNB = PNB.';
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);    
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2);
            T.S(n) = T.S2(n)*pjoin.acfac(n);
            T.S(n) = T.S2(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*(T.Var7(n)+T.Var8(n)+T.Var9(n))/3;
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
        end
        T = sortrows(T,10,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:12);
        T(n:end,:) = [];
        T2 = sortrows(T2,12,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = []; 
        ofn = strcat(ofn1,'_combined.csv');
        ofn2 = strcat(ofn1,'_combined_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 7
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;        
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms(1)};
                nb(1) = pjoin.total_b(ms(1));
        if (numel(ms)>1)
            for m = 2:numel(ms)
                SM = union(SM,pjoin.member_url{ms(m)});
                nb(m) = pjoin.total_b(ms(m));
            end
        end
        [mbm,i] = max(nb);
        m = ms(i);
        ofn1 = pjoin.band{m};
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        mnames = cell(height(pjoin),1);
        murls = cell(height(pjoin),1);
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);          
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            [murls{n},j] = intersect(M{n},M{m});
            mnames{n} = MN{n}(j);
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
        end
        PNM = PNM.';
        PNB = PNB.';
        TM = table(pjoin.id,mnames,murls,IBI);
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);        
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);     
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2);
            T.S(n) = T.S(n)*pjoin.acfac(n);
            T.S(n) = T.S(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*(T.Var7(n)+T.Var8(n)+T.Var9(n))/3;
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var7(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
            T.M{n} = TM{n,2};
            T.MU{n} = TM{n,3};
        end
        T = sortrows(T,10,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:14);       
        T(n:end,:) = [];
        T2 = sortrows(T2,12,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = []; 
        ofn = strcat(ofn1,'_combined.csv');
        ofn2 = strcat(ofn1,'_combined_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 8 
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;        
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms(1)};
         nb(1) = pjoin.total_b(ms(1));
        if (numel(ms)>1)
            for m = 2:numel(ms)
                SM = union(SM,pjoin.member_url{ms(m)});
                nb(m) = pjoin.total_b(ms(m));
            end
        end
        [mbm,i] = max(nb);
        m = ms(i);
        ofn1 = pjoin.band{m};
        I_Select = pjoin.stemInst{m};
        I = pjoin.stemInst; 
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        PNI = double(height(pjoin));
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);      
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
            if (numel(I{n})~=0)
                In = I{n};
                II = intersect(I_Select,In);
                PNI(n) = numel(II)/numel(I_Select);
            else
                PNI(n) = 0;
            end            
        end
        PNM = PNM.';
        PNB = PNB.';
        PNI = PNI.';
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL,PNI);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);        
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);     
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var10(n);
            T.S(n) = T.S(n)*pjoin.acfac(n);
            T.S(n) = T.S(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n)+T.Var9(n))/3)*T.Var10(n);
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S3(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var9(n)*T.Var10(n);
            T.S3(n) = T.S3(n)*pjoin.acfac(n);
            T.S3(n) = T.S3(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
        end
        T = sortrows(T,12,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:14);
        T(n:end,:) = [];
        T2 = sortrows(T2,14,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = [];
        ofn = strcat(ofn1,'_combined.csv');
        ofn2 = strcat(ofn1,'_combined_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 9
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;        
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms(1)};
        nb(1) = pjoin.total_b(ms(1));
        if (numel(ms)>1)
            for m = 2:numel(ms)
                SM = union(SM,pjoin.member_url{ms(m)});
                nb(m) = pjoin.total_b(ms(m));
            end
        end
        [mbm,i] = max(nb);
        m = ms(i);
        ofn1 = pjoin.band{m};
        I_Select = pjoin.stemInst{m};
        I = pjoin.stemInst; 
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        PNI = double(height(pjoin));
        mnames = cell(height(pjoin),1);
        murls = cell(height(pjoin),1);
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);      
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            [murls{n},j] = intersect(M{n},M{m});
            mnames{n} = MN{n}(j);
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
            if (numel(I{n})~=0)
                In = I{n};
                II = intersect(I_Select,In);
                PNI(n) = numel(II)/numel(I_Select);
            else
                PNI(n) = 0;
            end            
        end
        PNM = PNM.';
        PNB = PNB.';
        PNI = PNI.';
        TM = table(pjoin.id,mnames,murls);
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL,PNI);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);        
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);   
        TM = sortrows(TM,1);
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var10(n);
            T.S(n) = T.S(n)*pjoin.acfac(n);
            T.S(n) = T.S(n)*pjoin.alfac(n);
            T.S2(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n)+T.Var9(n))/3)*T.Var10(n);
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S3(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var9(n)*T.Var10(n);
            T.S3(n) = T.S3(n)*pjoin.acfac(n);
            T.S3(n) = T.S3(n)*pjoin.alfac(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
            T.M{n} = TM{n,2};
            T.MU{n} = TM{n,3};
        end
        T = sortrows(T,12,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:16);
        T(n:end,:) = [];
        T2 = sortrows(T2,14,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = [];   
        ofn = strcat(ofn1,'_combined.csv');
        ofn2 = strcat(ofn1,'_combined_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
    case 10
        for n = 1:height(pjoin)
            try CM{n} = categorical(pjoin.core_members{n}(2,:));
            catch
            end
        end
        pjoin = sortrows(pjoin,4);
        sincelast = pjoin.sincelast;
        SL = 1-sf.cdf(sincelast);
        B = pjoin.bands;
        M = pjoin.member_url;
        MN = pjoin.members;        
        ms = listdlg('PromptString', 'I want to find bands like: ',...
            'ListString',pjoin.menudisp,...
            'ListSize',[320,600]);
        SM = pjoin.member_url{ms(1)};
        if (numel(ms)>1)
            for m = 2:numel(ms)
                SM = union(SM,pjoin.member_url{ms(m)});
            end
        end            
        m = listdlg('SelectionMode','single','ListSize',[320,600],'ListString',pjoin.menudisp);
        ofn1 = pjoin.band{m};
        I_Select = pjoin.stemInst{m};
        I = pjoin.stemInst; 
        IBI = cell(height(pjoin),1);
        PNM = double(height(pjoin));
        PNB = double(height(pjoin));
        PNI = double(height(pjoin));
        mnames = cell(height(pjoin),1);
        murls = cell(height(pjoin),1);
        for n = 1:height(pjoin)
            p = intersect(SM,pjoin.member_url{n});
            P = union(SM,pjoin.member_url{n});
            IBI{n} = numel(p)/numel(P);      
            NP = numel(M{m});
            if (NP<1)
                NP = 1;
            end
            PNM(n) = numel(intersect(M{n},M{m}))/NP;
            if isnan(PNM(n))
                PNM(n) = 0;
            end
            [murls{n},j] = intersect(M{n},M{m});
            mnames{n} = MN{n}(j);
            CMK(n) = 1+numel(intersect(CM{m},MN{n}));
            NB = numel(B{n});
            if (NB<1)
                NB = 1;
            end
            PNB(n) = numel(intersect(B{n},B{m}))/NB;
            if isnan(PNB(n))
                PNB(n) = 0;
            end
            if (numel(I{n})~=0)
                In = I{n};
                II = intersect(I_Select,In);
                PNI(n) = numel(II)/numel(I_Select);
            else
                PNI(n) = 0;
            end            
        end
        PNM = PNM.';
        PNB = PNB.';
        PNI = PNI.';
        CMK = CMK.';
        TM = table(pjoin.id,mnames,murls);
        T = table(pjoin.id,pjoin.band,pjoin.genre,pjoin.country,pjoin.active,IBI,PNM,PNB,SL,PNI,CMK);
        T = sortrows(T,6,'descend');
        scaling_fac1 = T.Var6{2};
        T = sortrows(T,7,'descend');
        scaling_fac2 = T.Var7(2);        
        T = sortrows(T,8,'descend');
        scaling_fac3 = T.Var8(1);
        T = sortrows(T,1);      
        pjoin = sortrows(pjoin,5);
        TM = sortrows(TM,1);
        for n = 1:height(pjoin)
            if(T.Var6{n}<1)
                T.Var6{n} = T.Var6{n}/scaling_fac1;
            end
            if(T.Var7(n)<1)
                T.Var7(n) = T.Var7(n)/scaling_fac2;
            end
            if(T.Var8(n)==1)
                if(T.Var6{n}==0)
                    T.Var8(n)=0;
                end
            else
                T.Var8(n) = T.Var8(n)/scaling_fac3;
            end
            if isnan(T.Var9(n))
                T.Var9(n) = 0;
            end
            T.S(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var10(n);
            T.S(n) = T.S(n)*pjoin.acfac(n);
            T.S(n) = T.S(n)*pjoin.alfac(n);
            T.S(n) = T.S(n)*T.Var11(n);
            T.S2(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n)+T.Var9(n))/3)*T.Var10(n);
            T.S2(n) = T.S2(n)*pjoin.acfac(n);
            T.S2(n) = T.S2(n)*pjoin.alfac(n);
            T.S2(n) = T.S2(n)*T.Var11(n);
            T.S3(n) = T.Var6{n}*((T.Var7(n)+T.Var8(n))/2)*T.Var9(n)*T.Var10(n);
            T.S3(n) = T.S3(n)*pjoin.acfac(n);
            T.S3(n) = T.S3(n)*pjoin.alfac(n);
            T.S3(n) = T.S3(n)*T.Var11(n);
            T.S4(n) = T.Var8(n)*T.Var9(n)*T.Var10(n);
            T.S4(n) = T.S4(n)*pjoin.acfac(n);
            T.S4(n) = T.S4(n)*pjoin.alfac(n);
            T.M{n} = TM{n,2};
            T.MU{n} = TM{n,3};
        end
        T = sortrows(T,14,'descend');
        for n = 1:height(T)
            if (T.S(n)==0)
                break    
            end
        end
        T2 = T(n:end,1:17);
        T(n:end,:) = [];
        T2 = sortrows(T2,15,'descend');
        for n = 1:height(T2)
            if (T2.S4(n)==0)
                break
            end
        end
        T2(n:end,:) = []; 
        ofn = strcat(ofn1,'_combined_ex.csv');
        ofn2 = strcat(ofn1,'_combined_ex_indirect.csv');
        writetable(T,ofn);
        writetable(T2,ofn2);
        IBI = [];PNM=[];PNB=[];PNI=[];I_Select=[];I=[];mnames = [];murls=[];
end

