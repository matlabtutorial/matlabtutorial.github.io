clear; close all; clc;

%% New Contents

my_title = "MATLAB on Apple Silicon Macs";
my_link = "https://kr.mathworks.com/support/requirements/apple-silicon.html";
my_contents = "하반기에 출시될 R2023b 버전 부터는 Apple Silicon Mac에서 MATLAB이 로제타 없이 native로 돌아갈 수 있게 된다고 하네요!";
my_date = string(datetime(2023, 06, 16, "Format","yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"));
% my_date = "";

%% Posting to RSS
xmlfile = 'NEWS_on_MATLAB.xml';

S = readstruct(xmlfile);
template = S.entry(1);

% get all entry ids
updateCount = 0;
template.id = "";
if isempty(my_date) || strcmp(my_date,"")
    template.published = string(datetime("now", 'format',"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"));
else
    template.published = my_date;
end
template.updated = template.published;
template.link.hrefAttribute = my_link;
template.title = my_title;
template.content= my_contents;
template.author.name = "";
template.author.uri = "";

S.entry = [template, S.entry];

S.updated = string(datetime('now','format',"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"));


%% Check for duplicate entities

n_entry = length(S.entry);

if n_entry > 1 % only when there are more than 1 entity
    toDelete = false(1, n_entry);
    for i_entry = 1:n_entry
        for j_entry = i_entry+1:n_entry
            if strcmp(S.entry(i_entry).title, S.entry(j_entry).title)
                toDelete(i_entry) = true;
            end
        end
    end

    S.entry(toDelete) = [];
end

clear toDelete i_entry j_entry

%% sort entities by date

[~, idx] = sort([S.entry.published],'descend');

S.entry = S.entry(idx);
writestruct(S, 'NEWS_on_MATLAB.xml',"structNodeName","feed")

%% WRITE MD
baseTemplate = "---" + newline + ...
    "title: News" + newline + ...
    "sidebar: None" + newline + ...
    "permalink: news.html" + newline + ...
    "folder: matlab_basics" + newline + ...
    "identifier: news" + newline + ...
    "comments: false" + newline + ...
    "---" + newline + newline + ...
    "<p><a href='https://raw.githubusercontent.com/matlabtutorial/matlabtutorial.github.io/main/pages/news/NEWS_on_MATLAB.xml' class='btn btn-primary navbar-btn cursorNorm' role='button'>News RSS{{tag}}</a></p>";

mdContents = baseTemplate;
n_entry = length(S.entry);
for i_entry = 1:n_entry
    newtime = string(datestr(datetime(S.entry(i_entry).published, 'inputFormat', "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"), "yyyy-mm-dd"));
    newFeed = "{% include callout.html content=""<b><a target='_blank' href = '"+S.entry(i_entry).link.hrefAttribute + "'>" + S.entry(i_entry).title + "</a></b>, " ...
        + newtime + "<br><br>요약: " + S.entry(i_entry).content + "<br><br> <a target = '_blank' href = '"+ S.entry(i_entry).link.hrefAttribute + "'> 기사 전문 보기 </a> "" type = ""primary"" %}";

    mdContents = mdContents + newline + newline + newFeed;
end

writelines(mdContents, "matlab_news.md")

%% git push
% !git add NEWS_on_MATLAB.xml matlab_news.md && git commit -m "Updated MATLAB NEWS RSS"
% !git push