# Install curl if you don't have it
sudo apt update
sudo apt install -y curl

# Add NodeSource repository for Node.js 21 (updated from version 18)
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -

# Install Node.js and npm
sudo apt install -y nodejs

# Verify installation
node --version
npm --version


# Install pnpm globally
npm install -g pnpm

# Verify installation
pnpm --version


pnpm install
pnpm build
pnpm start -p 3012