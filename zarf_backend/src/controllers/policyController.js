import Policy from '../models/Policy.js';
import { NotFoundError, ValidationError } from '../middleware/errorHandler.js';

const ALLOWED_TYPES = ['amount_limit', 'weekend_submission'];
const ALLOWED_ACTIONS = ['warn', 'block'];

export const getPolicies = async (req, res, next) => {
  try {
    const policies = await Policy.find({ companyId: req.user.companyId })
      .sort({ createdAt: 1 })
      .lean();
    res.json({ success: true, data: policies });
  } catch (err) {
    next(err);
  }
};

export const createPolicy = async (req, res, next) => {
  try {
    const { name, type, category, threshold, action, enabled } = req.body;

    if (!name || typeof name !== 'string' || name.trim().length === 0) {
      throw new ValidationError('name is required');
    }
    if (!ALLOWED_TYPES.includes(type)) {
      throw new ValidationError(`type must be one of: ${ALLOWED_TYPES.join(', ')}`);
    }
    if (type === 'amount_limit' && (threshold == null || Number(threshold) <= 0)) {
      throw new ValidationError('threshold (positive number in base currency) is required for amount_limit policies');
    }
    if (action && !ALLOWED_ACTIONS.includes(action)) {
      throw new ValidationError(`action must be one of: ${ALLOWED_ACTIONS.join(', ')}`);
    }

    const policy = await Policy.create({
      companyId: req.user.companyId,
      name: name.trim(),
      type,
      category: category || null,
      threshold: type === 'amount_limit' ? Number(threshold) : null,
      action: action || 'warn',
      enabled: enabled !== undefined ? Boolean(enabled) : true
    });

    res.status(201).json({ success: true, data: policy });
  } catch (err) {
    next(err);
  }
};

export const updatePolicy = async (req, res, next) => {
  try {
    const policy = await Policy.findOne({
      _id: req.params.id,
      companyId: req.user.companyId
    });
    if (!policy) throw new NotFoundError('Policy not found');

    const { name, category, threshold, action, enabled } = req.body;

    if (name !== undefined) policy.name = String(name).trim();
    if (category !== undefined) policy.category = category || null;
    if (threshold !== undefined) {
      policy.threshold = threshold != null ? Number(threshold) : null;
    }
    if (action !== undefined) {
      if (!ALLOWED_ACTIONS.includes(action)) {
        throw new ValidationError(`action must be one of: ${ALLOWED_ACTIONS.join(', ')}`);
      }
      policy.action = action;
    }
    if (enabled !== undefined) policy.enabled = Boolean(enabled);

    await policy.save();
    res.json({ success: true, data: policy });
  } catch (err) {
    next(err);
  }
};

export const deletePolicy = async (req, res, next) => {
  try {
    const policy = await Policy.findOneAndDelete({
      _id: req.params.id,
      companyId: req.user.companyId
    });
    if (!policy) throw new NotFoundError('Policy not found');
    res.json({ success: true, message: 'Policy deleted' });
  } catch (err) {
    next(err);
  }
};
