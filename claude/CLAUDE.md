# Claude Memory

## PR Review Guidelines

When reviewing pull requests, always incorporate existing comments and discussions to provide comprehensive, context-aware reviews.

### Review Process Steps

1. **First fetch and analyze existing comments**
   - Use `gh api /repos/{owner}/{repo}/issues/{number}/comments` for PR-level comments
   - Use `gh api /repos/{owner}/{repo}/pulls/{number}/comments` for code review comments
   - Parse both comment types to understand ongoing discussions

2. **Reference them in my review when relevant**
   - Acknowledge existing feedback when building upon it
   - Provide context about whether issues are known vs. overlooked
   - Reference specific comment threads when adding related observations

3. **Focus on areas not yet covered**
   - Avoid duplicating issues already identified by other reviewers
   - Identify gaps in existing review coverage
   - Add fresh perspectives on unaddressed aspects

4. **Highlight when I agree/disagree with existing feedback**
   - Support valid concerns raised by other reviewers
   - Respectfully disagree when warranted with clear reasoning
   - Clarify or expand on points that need more detail

This ensures reviews are comprehensive, collaborative, and contextually informed.
