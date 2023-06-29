Tags = [];

D = dir("../../_posts/*.md");
filenames = {D.name}; clear D;

for i_file = 1:length(filenames)
    myStr = readlines("../../_posts/"+filenames{i_file});

    temp = extractAfter(myStr, "tags:");
    temp(ismissing(temp)) = [];
    temp = extractBetween(temp, "[", "]");

    Tags = [Tags; erase(split(temp, ","), " ")];
end

% tags 초기화
D = dir("*.md");
filenames = {D.name}; clear D;

for i_file = 1:length(filenames)
    delete(filenames{i_file});
end

TagsUnique = unique(Tags);
for i_tag = 1:length(TagsUnique)
    outStr = strTemplate(TagsUnique(i_tag));
    writelines(outStr, "tag_"+TagsUnique(i_tag)+".md");
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