REMOTE="origin"
SOURCE_BRANCH="master"
PUBLISH_BRANCH="gh-pages"
DATE=Time.now.strftime("%Y/%m/%d %H:%M")

desc "compile and publish the site to Github"
task :publish do
  sh "git checkout #{SOURCE_BRANCH}"
  comment = %x{ git log -n 1 --no-merges --format=%s%b }.chomp.strip
  sh "bundle exec middleman build"
  sh "cd build && git add -A && git commit -m \"At #{DATE} #{comment}\" && git push #{REMOTE} #{PUBLISH_BRANCH}"
  sh "git push origin #{SOURCE_BRANCH}"
end

namespace :dict do

  desc "Generate ID spans for dictionary entries"
  task :ids do
    source = "source/dict.html.md"

    lines = File.readlines(source).map { |line|
      line.sub(%r{^- \*\*(.*)\*\*(.*)$},'- <span id="\1">**\1**</span>\2')
    }
    File.open(source,"w") { |f| f.print lines.join; f.close }
  end

  task :sort do
    source = "source/dict.html.md"

    lines = File.readlines(source)
    start = lines.find_index { |x| x =~ %r{<start />} }
    head = lines[0..start]

    entries = lines - head

    File.open(source,"w") { |f| f.print (head + ["\n"] + entries.sort).join; f.close }

  end

end
