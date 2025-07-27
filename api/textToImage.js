// File: api/textToImage.js
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Only POST requests allowed' });
  }

  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' });
  }

  const response = await fetch('https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-2', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${process.env.TEXT_TO_IMAGE_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ inputs: prompt }),
  });

  if (!response.ok) {
    const err = await response.text();
    return res.status(500).json({ error: err });
  }

  const buffer = await response.arrayBuffer();
  const base64Image = Buffer.from(buffer).toString('base64');
  res.status(200).json({ image: `data:image/png;base64,${base64Image}` });
}
