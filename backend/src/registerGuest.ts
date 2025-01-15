// ~/Dev/WDNG.IO/backend/src/routes/registerRoute.ts
import { Request, Response } from 'express';
import AccessCode from './models/AccessCode';


const registerGuest = async (req: Request, res: Response): Promise<any> => {
  try {
    const { code, name, email, companion } = req.body;

    if (!code) {
      return res.status(400).json({ error: 'No code provided' });
    }

    // Find the document by code
    const foundCode = await AccessCode.findOne({ code });
    if (!foundCode) {
      return res.status(404).json({ error: 'Invalid code' });
    }

    // Update fields
    foundCode.name = name;
    foundCode.email = email;
    // companion might be undefined in some categories
    if (typeof companion === 'number') {
      foundCode.companion = companion;
    }

    // Mark as used (optional, if you want to track once they've registered)
    foundCode.used = true;

    // Save changes
    await foundCode.save();

    return res.json({
      success: true,
      updatedCode: {
        name: foundCode.name,
        email: foundCode.email,
        companion: foundCode.companion,
        category: foundCode.category,
        used: foundCode.used,
      },
    });
  } catch (error) {
    console.error('Error registering code:', error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

export default registerGuest;