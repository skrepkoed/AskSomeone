shared_examples_for 'resource saved' do
  it 'increments the number of resource by 1' do
    expect { perform }.to change { resource_collection.count }.by(1)
  end
end
