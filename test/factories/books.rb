Factory.define :foundation, :class => Book do |b|
  b.name 'Foundation'
  b.genre 'sci-fi'
  b.position 1
  b.author_id 1
end

Factory.define :robots, :class => Book do |b|
  b.name 'Robots'
  b.genre 'sci-fi'
  b.position 2
  b.author_id 1
end

Factory.define :neuromancer, :class => Book do |b|
  b.name 'Neuromancer'
  b.genre 'cyberpunk'
  b.position 3
  b.author_id 2
end