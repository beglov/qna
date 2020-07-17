shared_examples 'invalid params' do |model: nil, code: nil, template: nil|
  if model
    it "does't create #{model}" do
      expect { subject }.to_not change(model, :count)
    end
  end

  if code
    it "returns #{code} code" do
      expect(subject).to have_http_status(code)
    end
  end

  if template
    it "renders #{template} template" do
      expect(subject).to render_template template
    end
  end
end
