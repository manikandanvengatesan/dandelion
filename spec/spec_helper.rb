require 'dandelion'
require 'rugged'

Dandelion.logger.level = Logger::UNKNOWN

def test_repo(name = nil)
  name ||= 'repo'
  path = File.join(File.dirname(__FILE__), 'fixtures', "#{name}.git")
  @repo ||= Rugged::Repository.new(path)
end

def test_commits
  [
    test_repo.lookup('e289ff1e2729839759dbd6fe99b6e35880910c7c'),
    test_repo.lookup('3d9b743acb4a84dd99002d2c6f3fcf1a47e9f06b')
  ]
end

def test_tree(options = {})
  repo = options[:repo] || test_repo
  commit = options[:commit] || test_commits.last

  Dandelion::Tree.new(repo, commit)
end

def test_changeset(options = {})
  Dandelion::Changeset.new(test_tree, test_commits.first, options)
end

def test_changeset_with_symlinks(options = {})
  repo = test_repo('repo_symlink')
  commit0 = repo.lookup('3d9b743acb4a84dd99002d2c6f3fcf1a47e9f06b')
  commit1 = repo.lookup('4c19bbe7ba04230a0ae2281c1abbc48a76a66550')
  tree = test_tree(repo: repo, commit: commit1)
  Dandelion::Changeset.new(tree, commit0, options)
end

def test_diff
  test_changeset.diff
end