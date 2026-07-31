class WebDashboardUI {
  static const String htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vittix Wallet Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --bg-base: #0f172a;
            --bg-surface: #1e293b;
            --bg-surface-hover: #334155;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-primary: #3b82f6;
            --accent-primary-hover: #2563eb;
            --accent-success: #10b981;
            --accent-danger: #ef4444;
            --border-color: #334155;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-base);
            color: var(--text-primary);
            margin: 0;
            padding: 0;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background-color: var(--bg-surface);
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            padding: 24px 0;
        }
        .sidebar-header {
            padding: 0 24px 24px;
            font-size: 20px;
            font-weight: 700;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .sidebar-header svg {
            width: 24px;
            height: 24px;
            fill: var(--accent-primary);
        }
        
        .wallet-switcher {
            margin: 0 24px 24px;
        }
        .wallet-switcher select {
            width: 100%;
            background: var(--bg-base);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
        }
        .wallet-switcher select:focus {
            border-color: var(--accent-primary);
        }

        .nav-item {
            padding: 12px 24px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.2s;
            cursor: pointer;
        }
        .nav-item:hover {
            background-color: var(--bg-surface-hover);
            color: var(--text-primary);
        }
        .nav-item.active {
            color: var(--accent-primary);
            border-right: 4px solid var(--accent-primary);
            background-color: rgba(59, 130, 246, 0.1);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 32px;
            overflow-y: auto;
        }
        .header {
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        h1 {
            margin: 0 0 8px 0;
            font-size: 28px;
            font-weight: 700;
        }
        p.subtitle {
            margin: 0;
            color: var(--text-secondary);
        }

        /* Buttons & Forms */
        button {
            background-color: var(--accent-primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        button:hover { background-color: var(--accent-primary-hover); }
        button.danger { background-color: var(--accent-danger); }
        button.danger:hover { background-color: #dc2626; }
        button.secondary { background-color: var(--bg-surface-hover); color: var(--text-primary); border: 1px solid var(--border-color); }
        button.secondary:hover { background-color: var(--border-color); }
        button.small { padding: 6px 12px; font-size: 12px; }

        .form-card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 32px;
            display: none;
        }
        .form-card.active { display: block; }
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: var(--text-secondary);
            font-weight: 500;
        }
        .form-group input, .form-group select {
            width: 100%;
            background-color: var(--bg-base);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: var(--accent-primary);
            outline: none;
        }
        .form-row { display: flex; gap: 16px; }
        .form-row .form-group { flex: 1; }

        /* Cards Grid */
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }
        .card {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
            display: flex;
            flex-direction: column;
        }
        .card-title {
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
        }
        .card-value { font-size: 36px; font-weight: 700; }
        .value-positive { color: var(--accent-success); }
        .value-negative { color: var(--accent-danger); }

        /* Tables */
        .table-container {
            background-color: var(--bg-surface);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        th, td {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border-color);
        }
        th {
            background-color: rgba(0,0,0,0.2);
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: var(--bg-surface-hover); }
        .type-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge-income { background-color: rgba(16, 185, 129, 0.1); color: var(--accent-success); }
        .badge-expense { background-color: rgba(239, 68, 68, 0.1); color: var(--accent-danger); }
        .actions-cell { display: flex; gap: 8px; }

        /* Loader */
        .loader {
            display: inline-block;
            width: 24px;
            height: 24px;
            border: 3px solid var(--border-color);
            border-radius: 50%;
            border-top-color: var(--accent-primary);
            animation: spin 1s ease-in-out infinite;
            margin: auto;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        .loading-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 48px;
        }

        /* View Control */
        .view { display: none; }
        .view.active { display: block; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">
            <svg viewBox="0 0 24 24"><path d="M21 18V19C21 20.1 20.1 21 19 21H5C3.89 21 3 20.1 3 19V5C3 3.9 3.89 3 5 3H19C20.1 3 21 3.9 21 5V6H12C10.89 6 10 6.9 10 8V16C10 17.1 10.89 18 12 18H21ZM12 16H22V8H12V16ZM16 13.5C15.17 13.5 14.5 12.83 14.5 12C14.5 11.17 15.17 10.5 16 10.5C16.83 10.5 17.5 11.17 17.5 12C17.5 12.83 16.83 13.5 16 13.5Z"/></svg>
            Vittix
        </div>

        <div class="wallet-switcher">
            <label style="font-size: 12px; color: var(--text-secondary); margin-bottom: 6px; display: block;">ACTIVE WALLET</label>
            <select id="wallet-select" onchange="switchWallet(this.value)">
                <option value="">Loading...</option>
            </select>
        </div>

        <div class="nav-item active" onclick="switchView('dashboard', this)">Dashboard</div>
        <div class="nav-item" onclick="switchView('transactions', this)">Transactions</div>
        <div class="nav-item" onclick="switchView('accounts', this)">Accounts</div>
        <div class="nav-item" onclick="switchView('categories', this)">Categories</div>
    </div>

    <div class="main-content">
        
        <!-- Dashboard View -->
        <div id="view-dashboard" class="view active">
            <div class="header">
                <div>
                    <h1>Overview</h1>
                    <p class="subtitle">Your financial summary at a glance.</p>
                </div>
            </div>
            
            <div class="cards-grid">
                <div class="card">
                    <div class="card-title">Net Balance</div>
                    <div class="card-value" id="net-balance"><div class="loader"></div></div>
                </div>
                <div class="card">
                    <div class="card-title">Total Accounts</div>
                    <div class="card-value" id="total-accounts">-</div>
                </div>
                <div class="card">
                    <div class="card-title">Recent Transactions</div>
                    <div class="card-value" id="total-transactions">-</div>
                </div>
            </div>

            <div class="cards-grid">
                <div class="card" style="grid-column: span 2;">
                    <div class="card-title">6-Month Trend (Income vs Expenses)</div>
                    <canvas id="trendChart" height="80"></canvas>
                </div>
                <div class="card">
                    <div class="card-title">Expense Breakdown</div>
                    <canvas id="categoryChart" height="200"></canvas>
                </div>
            </div>

            <h2>Recent Activity</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Date</th><th>Account</th><th>Category</th><th>Type</th><th>Amount</th></tr>
                    </thead>
                    <tbody id="recent-transactions-tbody">
                        <tr><td colspan="5"><div class="loading-container"><div class="loader"></div></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Transactions View -->
        <div id="view-transactions" class="view">
            <div class="header">
                <div>
                    <h1>Transactions</h1>
                    <p class="subtitle">Manage all your recorded transactions.</p>
                </div>
                <button onclick="openTransactionForm()">New Transaction</button>
            </div>
            
            <div id="tx-form-card" class="form-card">
                <h3 id="tx-form-title" style="margin-top:0;">Create New Transaction</h3>
                <form onsubmit="saveTransaction(event)">
                    <input type="hidden" id="tx-id">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Type</label>
                            <select id="tx-type" required>
                                <option value="expense">Expense</option>
                                <option value="income">Income</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Amount</label>
                            <input type="number" id="tx-amount" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label>Date</label>
                            <input type="datetime-local" id="tx-date" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Account</label>
                            <select id="tx-account" required></select>
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select id="tx-category" required></select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Note</label>
                        <input type="text" id="tx-note" placeholder="Optional notes...">
                    </div>
                    <div style="display:flex; gap:12px;">
                        <button type="submit" id="tx-submit-btn">Save</button>
                        <button type="button" class="danger" onclick="closeForm('tx-form-card')">Cancel</button>
                    </div>
                </form>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Date</th><th>Account</th><th>Category</th><th>Type</th><th>Amount</th><th>Actions</th></tr>
                    </thead>
                    <tbody id="all-transactions-tbody">
                        <tr><td colspan="6"><div class="loading-container"><div class="loader"></div></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Accounts View -->
        <div id="view-accounts" class="view">
            <div class="header">
                <div>
                    <h1>Accounts</h1>
                    <p class="subtitle">Manage your bank accounts, cards, and wallets.</p>
                </div>
                <button onclick="openAccountForm()">New Account</button>
            </div>

            <div id="account-form-card" class="form-card">
                <h3 id="acc-form-title" style="margin-top:0;">Create New Account</h3>
                <form onsubmit="saveAccount(event)">
                    <input type="hidden" id="acc-id">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Account Name</label>
                            <input type="text" id="acc-name" required placeholder="e.g. Chase Checkings">
                        </div>
                        <div class="form-group">
                            <label>Type</label>
                            <select id="acc-type">
                                <option value="bank">Bank</option>
                                <option value="creditCard">Credit Card</option>
                                <option value="cash">Cash</option>
                                <option value="loan">Loan</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Opening Balance</label>
                            <input type="number" id="acc-balance" step="0.01" value="0.00" required>
                        </div>
                        <div class="form-group">
                            <label>Currency</label>
                            <select id="acc-currency">
                                <option value="USD">USD</option>
                                <option value="EUR">EUR</option>
                                <option value="INR">INR</option>
                                <option value="GBP">GBP</option>
                            </select>
                        </div>
                    </div>
                    <div style="display:flex; gap:12px;">
                        <button type="submit" id="acc-submit-btn">Save</button>
                        <button type="button" class="danger" onclick="closeForm('account-form-card')">Cancel</button>
                    </div>
                </form>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>Name</th><th>Type</th><th>Currency</th><th>Opening Balance</th><th>Actions</th></tr>
                    </thead>
                    <tbody id="all-accounts-tbody">
                        <tr><td colspan="5"><div class="loading-container"><div class="loader"></div></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Categories View -->
        <div id="view-categories" class="view">
            <div class="header">
                <div>
                    <h1>Categories</h1>
                    <p class="subtitle">Manage your global transaction categories.</p>
                </div>
                <button onclick="openCategoryForm()">New Category</button>
            </div>

            <div id="category-form-card" class="form-card">
                <h3 id="cat-form-title" style="margin-top:0;">Create New Category</h3>
                <form onsubmit="saveCategory(event)">
                    <input type="hidden" id="cat-id">
                    <div class="form-group">
                        <label>Category Name</label>
                        <input type="text" id="cat-name" required placeholder="e.g. Groceries">
                    </div>
                    <div style="display:flex; gap:12px;">
                        <button type="submit" id="cat-submit-btn">Save</button>
                        <button type="button" class="danger" onclick="closeForm('category-form-card')">Cancel</button>
                    </div>
                </form>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr><th>ID</th><th>Name</th><th>Actions</th></tr>
                    </thead>
                    <tbody id="all-categories-tbody">
                        <tr><td colspan="3"><div class="loading-container"><div class="loader"></div></div></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script>
        let cachedAccounts = [];
        let cachedCategories = [];
        let cachedTransactions = [];

        const formatCurrency = (amount) => {
            return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR' }).format(amount);
        };
        const formatDate = (dateString) => {
            const date = new Date(dateString);
            return new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' }).format(date);
        };
        const toInputDatetimeLocal = (dateString) => {
            const d = new Date(dateString);
            return new Date(d.getTime() - d.getTimezoneOffset() * 60000).toISOString().slice(0,16);
        };

        const switchView = (viewId, element) => {
            document.querySelectorAll('.view').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
            document.getElementById('view-' + viewId).classList.add('active');
            if (element) element.classList.add('active');
        };

        const closeForm = (formId) => {
            document.getElementById(formId).classList.remove('active');
        };

        // --- API Helpers ---
        const apiCall = async (endpoint, method = 'GET', body = null) => {
            const options = { method, headers: {} };
            if (body) {
                options.headers['Content-Type'] = 'application/json';
                options.body = JSON.stringify(body);
            }
            const res = await fetch(endpoint, options);
            return res.json();
        };

        // --- Wallets ---
        const loadWallets = async () => {
            try {
                const data = await apiCall('/api/wallets');
                const select = document.getElementById('wallet-select');
                select.innerHTML = data.wallets.map(w => 
                    `<option value="\${w.id}" \${w.id === data.currentWalletId ? 'selected' : ''}>\${w.name}</option>`
                ).join('');
            } catch (e) {
                console.error('Failed to load wallets', e);
            }
        };

        const switchWallet = async (id) => {
            await apiCall('/api/wallet/switch', 'POST', { id: parseInt(id) });
            loadData();
        };

        // --- Data Loading & Rendering ---
        const loadData = async () => {
            try {
                const [accounts, transactions, categories] = await Promise.all([
                    apiCall('/api/accounts'),
                    apiCall('/api/transactions'),
                    apiCall('/api/categories')
                ]);
                cachedAccounts = accounts;
                cachedCategories = categories;
                transactions.sort((a,b) => new Date(b.date) - new Date(a.date));
                cachedTransactions = transactions;

                renderAccounts();
                renderCategories();
                renderTransactions();
                updateDashboardWidgets();
                renderCharts();

                // Populate form dropdowns
                const txAccountSelect = document.getElementById('tx-account');
                txAccountSelect.innerHTML = accounts.map(a => `<option value="\${a.id}">\${a.name}</option>`).join('');
                const txCategorySelect = document.getElementById('tx-category');
                txCategorySelect.innerHTML = categories.map(c => `<option value="\${c.id}">\${c.name}</option>`).join('');

            } catch (err) {
                console.error("Failed to load data:", err);
            }
        };

        const updateDashboardWidgets = () => {
            let totalBalance = cachedAccounts.reduce((acc, curr) => acc + (curr.openingBalance || 0), 0);
            const netBalanceEl = document.getElementById('net-balance');
            netBalanceEl.innerText = formatCurrency(totalBalance);
            netBalanceEl.className = 'card-value ' + (totalBalance >= 0 ? 'value-positive' : 'value-negative');
            document.getElementById('total-accounts').innerText = cachedAccounts.length;
            document.getElementById('total-transactions').innerText = cachedTransactions.length;
        };

        let trendChartInstance = null;
        let categoryChartInstance = null;

        const renderCharts = () => {
            // Chart 1: Trend
            const trendData = {
                income: {},
                expense: {}
            };
            
            const sixMonthsAgo = new Date();
            sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6);

            cachedTransactions.forEach(tx => {
                const date = new Date(tx.date);
                if (date >= sixMonthsAgo) {
                    const monthKey = date.toLocaleString('default', { month: 'short', year: '2-digit' });
                    if (!trendData[tx.type][monthKey]) trendData[tx.type][monthKey] = 0;
                    trendData[tx.type][monthKey] += tx.amount;
                }
            });

            const labels = Array.from(new Set([...Object.keys(trendData.income), ...Object.keys(trendData.expense)])).sort((a,b) => {
                const [mA, yA] = a.split(' '); const [mB, yB] = b.split(' ');
                return new Date(mB + ' 1 ' + yB) < new Date(mA + ' 1 ' + yA) ? 1 : -1;
            });

            const incomeValues = labels.map(l => trendData.income[l] || 0);
            const expenseValues = labels.map(l => trendData.expense[l] || 0);

            if (trendChartInstance) trendChartInstance.destroy();
            const ctxTrend = document.getElementById('trendChart').getContext('2d');
            trendChartInstance = new Chart(ctxTrend, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        { label: 'Income', data: incomeValues, borderColor: '#10b981', tension: 0.4, fill: false },
                        { label: 'Expense', data: expenseValues, borderColor: '#ef4444', tension: 0.4, fill: false }
                    ]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { position: 'top', labels: { color: '#94a3b8' } } },
                    scales: {
                        x: { ticks: { color: '#94a3b8' }, grid: { color: '#334155' } },
                        y: { ticks: { color: '#94a3b8' }, grid: { color: '#334155' } }
                    }
                }
            });

            // Chart 2: Category Pie Chart
            const categoryTotals = {};
            cachedTransactions.forEach(tx => {
                if (tx.type === 'expense') {
                    const cat = cachedCategories.find(c => c.id === tx.categoryId);
                    const catName = cat ? cat.name : 'Unknown';
                    categoryTotals[catName] = (categoryTotals[catName] || 0) + tx.amount;
                }
            });

            if (categoryChartInstance) categoryChartInstance.destroy();
            const ctxCategory = document.getElementById('categoryChart').getContext('2d');
            categoryChartInstance = new Chart(ctxCategory, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(categoryTotals),
                    datasets: [{
                        data: Object.values(categoryTotals),
                        backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#14b8a6', '#f43f5e']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'bottom', labels: { color: '#94a3b8' } }
                    }
                }
            });
        };

        const renderAccounts = () => {
            let accHtml = '';
            cachedAccounts.forEach(acc => {
                accHtml += `
                    <tr>
                        <td><strong>\${acc.name}</strong></td>
                        <td style="text-transform: capitalize;">\${acc.type}</td>
                        <td>\${acc.currencyCode}</td>
                        <td>\${formatCurrency(acc.openingBalance)}</td>
                        <td class="actions-cell">
                            <button class="secondary small" onclick="openAccountForm(\${acc.id})">Edit</button>
                            <button class="danger small" onclick="deleteAccount(\${acc.id})">Delete</button>
                        </td>
                    </tr>
                `;
            });
            document.getElementById('all-accounts-tbody').innerHTML = accHtml || '<tr><td colspan="5">No accounts found.</td></tr>';
        };

        const renderCategories = () => {
            let catHtml = '';
            cachedCategories.forEach(cat => {
                catHtml += `
                    <tr>
                        <td style="color: var(--text-secondary)">#\${cat.id}</td>
                        <td><strong>\${cat.name}</strong></td>
                        <td class="actions-cell">
                            <button class="secondary small" onclick="openCategoryForm(\${cat.id})">Edit</button>
                            <button class="danger small" onclick="deleteCategory(\${cat.id})">Delete</button>
                        </td>
                    </tr>
                `;
            });
            document.getElementById('all-categories-tbody').innerHTML = catHtml || '<tr><td colspan="3">No categories found.</td></tr>';
        };

        const renderTransactions = () => {
            let recentTxHtml = '';
            let allTxHtml = '';
            
            cachedTransactions.forEach((tx, index) => {
                const acc = cachedAccounts.find(a => a.id === tx.accountId);
                const cat = cachedCategories.find(c => c.id === tx.categoryId);
                
                const typeBadge = tx.type === 'income' ? 'badge-income' : 'badge-expense';
                const amountStr = tx.type === 'expense' ? `-\${formatCurrency(tx.amount)}` : `+\${formatCurrency(tx.amount)}`;
                const amountClass = tx.type === 'expense' ? 'value-negative' : 'value-positive';

                const rowBody = `
                    <td>\${formatDate(tx.date)}</td>
                    <td>\${acc ? acc.name : '-'}</td>
                    <td>\${cat ? cat.name : '-'}</td>
                    <td><span class="type-badge \${typeBadge}">\${tx.type}</span></td>
                    <td class="\${amountClass}" style="font-weight: 600;">\${amountStr}</td>
                `;
                
                if (index < 5) {
                    recentTxHtml += `<tr>\${rowBody}</tr>`;
                }

                allTxHtml += `
                    <tr>
                        \${rowBody}
                        <td class="actions-cell">
                            <button class="secondary small" onclick="openTransactionForm(\${tx.id})">Edit</button>
                            <button class="danger small" onclick="deleteTransaction(\${tx.id})">Delete</button>
                        </td>
                    </tr>
                `;
            });

            document.getElementById('recent-transactions-tbody').innerHTML = recentTxHtml || '<tr><td colspan="5">No transactions found.</td></tr>';
            document.getElementById('all-transactions-tbody').innerHTML = allTxHtml || '<tr><td colspan="6">No transactions found.</td></tr>';
        };

        // --- Accounts CRUD ---
        const openAccountForm = (id = null) => {
            const form = document.getElementById('account-form-card');
            form.classList.add('active');
            if (id) {
                document.getElementById('acc-form-title').innerText = 'Edit Account';
                document.getElementById('acc-submit-btn').innerText = 'Update Account';
                const acc = cachedAccounts.find(a => a.id === id);
                document.getElementById('acc-id').value = acc.id;
                document.getElementById('acc-name').value = acc.name;
                document.getElementById('acc-type').value = acc.type;
                document.getElementById('acc-balance').value = acc.openingBalance;
                document.getElementById('acc-currency').value = acc.currencyCode;
            } else {
                document.getElementById('acc-form-title').innerText = 'Create New Account';
                document.getElementById('acc-submit-btn').innerText = 'Create Account';
                document.getElementById('acc-id').value = '';
                document.querySelector('#account-form-card form').reset();
            }
        };

        const saveAccount = async (e) => {
            e.preventDefault();
            const id = document.getElementById('acc-id').value;
            const payload = {
                name: document.getElementById('acc-name').value,
                type: document.getElementById('acc-type').value,
                openingBalance: parseFloat(document.getElementById('acc-balance').value),
                currencyCode: document.getElementById('acc-currency').value
            };
            if (id) {
                await apiCall('/api/accounts/' + id, 'PUT', payload);
            } else {
                await apiCall('/api/accounts', 'POST', payload);
            }
            closeForm('account-form-card');
            loadData();
        };

        const deleteAccount = async (id) => {
            if(!confirm('Are you sure you want to delete this account?')) return;
            await apiCall('/api/accounts/' + id, 'DELETE');
            loadData();
        };

        // --- Categories CRUD ---
        const openCategoryForm = (id = null) => {
            const form = document.getElementById('category-form-card');
            form.classList.add('active');
            if (id) {
                document.getElementById('cat-form-title').innerText = 'Edit Category';
                document.getElementById('cat-submit-btn').innerText = 'Update Category';
                const cat = cachedCategories.find(c => c.id === id);
                document.getElementById('cat-id').value = cat.id;
                document.getElementById('cat-name').value = cat.name;
            } else {
                document.getElementById('cat-form-title').innerText = 'Create New Category';
                document.getElementById('cat-submit-btn').innerText = 'Create Category';
                document.getElementById('cat-id').value = '';
                document.querySelector('#category-form-card form').reset();
            }
        };

        const saveCategory = async (e) => {
            e.preventDefault();
            const id = document.getElementById('cat-id').value;
            const payload = { name: document.getElementById('cat-name').value };
            if (id) {
                await apiCall('/api/categories/' + id, 'PUT', payload);
            } else {
                await apiCall('/api/categories', 'POST', payload);
            }
            closeForm('category-form-card');
            loadData();
        };

        const deleteCategory = async (id) => {
            if(!confirm('Are you sure you want to delete this category?')) return;
            await apiCall('/api/categories/' + id, 'DELETE');
            loadData();
        };

        // --- Transactions CRUD ---
        const openTransactionForm = (id = null) => {
            const form = document.getElementById('tx-form-card');
            form.classList.add('active');
            if (id) {
                document.getElementById('tx-form-title').innerText = 'Edit Transaction';
                document.getElementById('tx-submit-btn').innerText = 'Update Transaction';
                const tx = cachedTransactions.find(t => t.id === id);
                document.getElementById('tx-id').value = tx.id;
                document.getElementById('tx-type').value = tx.type;
                document.getElementById('tx-amount').value = tx.amount;
                document.getElementById('tx-date').value = toInputDatetimeLocal(tx.date);
                document.getElementById('tx-account').value = tx.accountId;
                document.getElementById('tx-category').value = tx.categoryId;
                document.getElementById('tx-note').value = tx.note || '';
            } else {
                document.getElementById('tx-form-title').innerText = 'Create New Transaction';
                document.getElementById('tx-submit-btn').innerText = 'Create Transaction';
                document.getElementById('tx-id').value = '';
                document.querySelector('#tx-form-card form').reset();
                document.getElementById('tx-date').value = toInputDatetimeLocal(new Date().toISOString());
            }
        };

        const saveTransaction = async (e) => {
            e.preventDefault();
            const id = document.getElementById('tx-id').value;
            const payload = {
                type: document.getElementById('tx-type').value,
                amount: parseFloat(document.getElementById('tx-amount').value),
                date: new Date(document.getElementById('tx-date').value).toISOString(),
                accountId: parseInt(document.getElementById('tx-account').value),
                categoryId: parseInt(document.getElementById('tx-category').value),
                note: document.getElementById('tx-note').value
            };
            if (id) {
                await apiCall('/api/transactions/' + id, 'PUT', payload);
            } else {
                await apiCall('/api/transactions', 'POST', payload);
            }
            closeForm('tx-form-card');
            loadData();
        };

        const deleteTransaction = async (id) => {
            if(!confirm('Are you sure you want to delete this transaction?')) return;
            await apiCall('/api/transactions/' + id, 'DELETE');
            loadData();
        };

        // Initialize
        loadWallets();
        loadData();
    </script>
</body>
</html>
''';
}
