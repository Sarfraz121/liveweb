# 📝 Commit Guide for LiveWeb

This document outlines the commit strategy for this repository.

## Commit Strategy

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependency updates
- `ci`: CI/CD changes
- `build`: Build system changes
- `config`: Configuration changes

### Examples

```bash
feat: add deployment infrastructure with GitHub Actions
feat: implement Docker support for production deployment

fix: resolve port conflict with existing services
fix: correct CORS configuration for production

docs: add comprehensive deployment documentation
docs: update README with deployment instructions

config: change default port from 3000 to 3001
config: update Nginx configuration for custom domains

ci: add GitHub Actions workflow for automated deployment
ci: configure deployment scripts for PM2

chore: update dependencies
chore: clean up temporary files
```

## Initial Commit Strategy

For the initial setup, commits should be organized logically:

1. **Infrastructure & Configuration**
   - Deployment infrastructure
   - Docker configuration
   - Port configuration

2. **Documentation**
   - Deployment guides
   - Setup instructions
   - Architecture documentation

3. **CI/CD**
   - GitHub Actions workflows
   - Deployment scripts

4. **Application Code**
   - Server configuration updates
   - Frontend build configuration
