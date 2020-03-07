ay = jsondecode(urlread('https://api.discogs.com/artists/263989/releases?per_page=500'))
for n = 1:130
s{n,1} = ay.releases{n}.title
s{n,2} = ay.releases{n}.role
try s{n,3} = ay.releases{n}.format
end
try s{n,4} = ay.releases{n}.year
end
s{n,5} = ay.releases{n}.id
s{n,6} = ay.releases{n}.resource_url
end
for n = 1:130
% pause(.1)
if ~isempty(strfind(s{n,2},'Main'))
    v = jsondecode(urlread(s{n,6}))
  % if isempty(strfind(s{n,6},'releases'))
        % [l,w] = size(v);
   try r{n} = jsondecode(urlread(v.most_recent_release_url));
   catch r{n} = jsondecode(urlread(v.resource_url))
   end
end

for n = 1:28
try [l,w] = size(unique(struct2table(r{n}.extraartists)))
ea(height(ea)+1:height(ea)+l,1:7) = struct2table(r{n}.extraartists)
end
end
ll = 0
for n = 1:28
try [l,w] = size(unique(struct2table(r{n}.extraartists)))
for m = 1:l
ea.V{ll+m} = r{n}.title;;
end
ll = ll+l
end
end

[e1,e2] = unique(ea(:,2))
ea3 = ea(e2,:)
for n = 1:235
a = jsondecode(urlread(strcat(char(ea3{n,6}),'/releases?per_page=500')));
a = a.releases;
ea3{n,9} = {a};
n
end

releases = cell(1,6)
current_rel = 0;
for n = 1:height(ea3)
    numr = numel(ea3.Var9{n})
    for m = 1:numr
        releases{current_rel+m,1} = ea3.name(n);
        releases{current_rel+m,2} = ea3.role(n);
        releases{current_rel+m,3} = ea3.V(n);
        releases{current_rel+m,4} = ea3.id(n);
        try releases{current_rel+m,5} =  ea3.Var9{n}{m}.artist;
        releases{current_rel+m,6} = ea3.Var9{n}{m}.title;
        releases{current_rel+m,7} = ea3.Var9{n}{m}.role;
        catch
            releases{current_rel+m,5} =  ea3.Var9{n}(m).artist;
        releases{current_rel+m,6} = ea3.Var9{n}(m).title;
        releases{current_rel+m,7} = ea3.Var9{n}(m).role;
        end
        try releases{current_rel+m,8} = ea3.Var9{n}{m}.year;
        catch
        end
        try releases{current_rel+m,9} = ea3.Var9{n}{m}.resource_url;
        catch 
        end
    end
    current_rel = current_rel +numr;
    
    
end