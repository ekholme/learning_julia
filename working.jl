#just a little playground for writing code
using PkgTemplates

t = Template(;
    user = "ekholme", #or your git user.name
    license = "MIT",
    authors = ["Eric Ekholm"],
    julia_version = v"1.8", #or w/e version you want
    plugins = [
        GitHubActions(),
        Codecov(),
        GitHubPages(),
        TravisCI()
    ]
)

t("Open5e")