import { Request, Response } from 'express';
import AccessCode from './models/AccessCode';


/**
 * POST /verify
 * Example body: { "code": "xyz-123" }
 * This route verifies an access code.
 */
const verifyAccessCode = async (req: Request, res: Response): Promise<any> => {
  try {
    const { code } = req.body;

    if (!code) {
      return res.status(400).json({ error: 'No code provided' });
    }

    // Use Mongoose to look up the code in MongoDB
    const foundCode = await AccessCode.findOne({ code });
    if (!foundCode) {
      // If the code isn't found, return an error
      return res.status(404).json({ error: 'Invalid code' });
    }

    // Code found - return success and any info you'd like.
    return res.json({
      success: true,
      category: foundCode.category,
      used: foundCode.used,
    });
  } catch (error) {
    console.error('Error verifying code:', error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
};

export default verifyAccessCode;