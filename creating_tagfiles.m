Tags = [];

D = dir("./_posts/*.md");
filenames = {D.name}; clear D;

for i_file = 1:length(filenames)
    myStr = readlines("./_posts/"+filenames{i_file});

    temp = extractAfter(myStr, "tags:");
    temp(ismissing(temp)) = [];
    temp = extractBetween(temp, "[", "]");
    temp = split(temp, ",");
    if any(startsWith(temp, " ")) % 공란으로 시작하는 문자열이 있는 경우
        idx2check = find(startsWith(temp, " "));
        for i_temp = idx2check'
            temp{i_temp}(1) = []; % 시작하는 공란 문자 제거
        end 
    end
    Tags = [Tags; temp];
end

% tags 초기화
D = dir("./pages/tags/*.md");
filenames = {D.name}; clear D;

for i_file = 1:length(filenames)
    delete("./pages/tags/"+filenames{i_file});
end

TagsUnique = unique(Tags);
for i_tag = 1:length(TagsUnique)
    outStr = strTemplate(TagsUnique(i_tag));
    writelines(outStr, "./pages/tags/tag_"+TagsUnique(i_tag)+".md");
end

function outStr = strTemplate(placeholder)
outStr = "---" + newline + ...
    "title: ""Tag: "+placeholder+"""" + newline + ...
    "tagName: "+placeholder+ newline + ...
    "search: exclude" + newline + ...
    "permalink: tag_"+placeholder+".html" + newline + ...
    "sidebar: False" + newline + ...
    "folder: tags" + newline + ...
    "---" + newline + ...
    "{% include taglogic.html %}" + newline + newline + ...
    "{% include links.html %}";
end