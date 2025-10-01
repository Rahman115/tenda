// app.js - Main Application Class
class JobManager {
  constructor() {
    this.selectedJobUuid = null
    this.selectedJobId = null
    this.selectedOrderUuid = null

    this.init()
  }

  init() {
    this.bindEvents()
    this.loadJobs()
    this.setupModalListeners()
  }

  setupModalListeners() {
    // Listen to modal events
    document.addEventListener('modal:open', e => {
      console.log(`Modal opened: ${e.detail.modalId}`)
      this.onModalOpen(e.detail.modalId)
    })

    document.addEventListener('modal:close', e => {
      console.log(`Modal closed: ${e.detail.modalId}`)
      this.onModalClose(e.detail.modalId)
    })
  }

  onModalOpen(modalId) {
    // Setup khusus ketika modal tertentu dibuka
    switch (modalId) {
      case 'addWorksModal':
        this.loadAvailableUsers()
        this.loadWorkers()
        break
      case 'addOrderModal':
        if (this.selectedJobUuid) {
          document.getElementById('uuid_kerjaan_display').textContent =
            this.selectedJobUuid
          document.getElementById('id_kerjaan').value = this.selectedJobId
        }
        break
    }
  }

  onModalClose(modalId) {
    // Cleanup ketika modal ditutup
    switch (modalId) {
      case 'addWorksModal':
        this.selectedOrderUuid = null
        break
      case 'editOrderModal':
        this.selectedOrderUuid = null
        break
    }
  }

  bindEvents() {
    // Form submissions
    document
      .getElementById('addOrderForm')
      ?.addEventListener('submit', e => this.handleAddOrder(e))
    document
      .getElementById('editOrderForm')
      ?.addEventListener('submit', e => this.handleEditOrder(e))
    document
      .getElementById('addJobsForm')
      ?.addEventListener('submit', e => this.handleAddJob(e))
    document
      .getElementById('editJobsForm')
      ?.addEventListener('submit', e => this.handleEditJob(e))
    document
      .getElementById('addWorksForm')
      ?.addEventListener('submit', e => this.handleAddWorker(e))
  }

  // ========== MODAL METHODS (Simplified) ==========
  showAddOrderModal() {
    if (!this.selectedJobUuid) {
      alert('Pilih pekerjaan terlebih dahulu!')
      return
    }
    modalManager.open('addOrderModal')
  }

  showEditOrderModal(order) {
    this.selectedOrderUuid = order.uuid
    modalManager.populateForm('editOrderModal', order, 'edit_')
    modalManager.open('editOrderModal')
  }

  showAddJobsModal() {
    modalManager.open('addJobsModal')
  }

  showEditJobModal(jobUuid, jobData) {
    if (jobData) {
      modalManager.populateForm('editJobsModal', jobData, 'edit_')
    }
    modalManager.open('editJobsModal')
  }

  showAddWorksModal(orderUuid) {
    this.selectedOrderUuid = orderUuid
    document.getElementById('kerjaan_uuid_display').textContent = orderUuid
    document.getElementById('kerjaan_uuid').value = orderUuid
    modalManager.open('addWorksModal')
  }

  closeDetail() {
    document.getElementById('detail').innerHTML = `
            <h2>Detail Pesanan</h2>
            <p>Pilih pekerjaan untuk melihat detail pesanan</p>
            <div id="order-list"></div>
            <button onclick="jobManager.showAddOrderModal()">+ Pesanan</button>
            <button onclick="jobManager.showAddJobsModal()">+ Pekerjaan</button>
        `
  }

  // ========== FORM HANDLERS (Updated) ==========
  async handleAddOrder(e) {
    e.preventDefault()
    modalManager.setLoading('addOrderModal', true)

    try {
      await this.submitForm('php/order_save.php', new FormData(e.target))
      modalManager.close('addOrderModal')
      this.loadOrders(this.selectedJobUuid)
    } finally {
      modalManager.setLoading('addOrderModal', false)
    }
  }

  async handleEditOrder(e) {
    e.preventDefault()
    modalManager.setLoading('editOrderModal', true)

    try {
      const formData = new FormData(e.target)
      formData.append('uuid', this.selectedOrderUuid)
      await this.submitForm('php/order_edit.php', formData)
      modalManager.close('editOrderModal')
      this.loadOrders(this.selectedJobUuid)
    } finally {
      modalManager.setLoading('editOrderModal', false)
    }
  }

  async handleAddJob(e) {
    e.preventDefault()
    modalManager.setLoading('addJobsModal', true)

    try {
      const formData = {
        pengguna: document.getElementById('pengguna').value,
        lokasi: document.getElementById('lokasi').value,
        status_pembayaran: document.getElementById('status_pembayaran').value,
        tanggal: document.getElementById('tanggal_job').value
      }

      await this.submitForm('php/job_save.php', formData, 'JSON')
      modalManager.close('addJobsModal')
      this.loadJobs()
    } finally {
      modalManager.setLoading('addJobsModal', false)
    }
  }

  async handleAddWorker(e) {
    e.preventDefault()
    modalManager.setLoading('addWorksModal', true)

    try {
      const formData = new FormData(e.target)
      const jsonData = Object.fromEntries(formData)

      await this.submitForm('php/pekerja_save.php', jsonData, 'JSON')
      this.loadWorkers()
      this.loadAvailableUsers()
    } finally {
      modalManager.setLoading('addWorksModal', false)
    }
  }

  // ========== JOBS MANAGEMENT ==========
  async loadJobs() {
    try {
      const response = await fetch('kerjaan.php')
      const jobs = await response.json()
      this.renderJobs(jobs)
    } catch (error) {
      console.error('Error loading jobs:', error)
      this.showError('job-list', 'Error loading data')
    }
  }

  renderJobs(jobs) {
    const container = document.getElementById('job-list')
    container.innerHTML = jobs
      .map(
        job => `
            <div class="card">
                <h3>${job.pengguna}</h3>
                <p><b>Lokasi:</b> ${job.lokasi}</p>
                <p><b>Status:</b> ${
                  job.status_pembayaran === 'no' ? 'Belum' : 'Sudah'
                }</p>
                <p><b>Tanggal:</b> ${job.tanggal}</p>
                <p class="uuid-display"><b>UUID:</b> ${job.uuid}</p>
                <button onclick="jobManager.selectJob('${job.uuid}', ${
                  job.id
                }, '${job.pengguna}')">Pilih</button>
                <button class="btn-edit" onclick="jobManager.showEditJobModal('${
                  job.uuid
                }')">Edit</button>
                <button class="btn-danger" onclick="jobManager.deleteJob('${
                  job.uuid
                }')">Hapus</button>
            </div>
        `
      )
      .join('')
  }

  selectJob(jobUuid, jobId, pengguna) {
    this.selectedJobUuid = jobUuid
    this.selectedJobId = jobId

    document.getElementById('detail').innerHTML = `
            <h2>Detail Pesanan - ${pengguna}</h2>
            <p><strong>UUID Pekerjaan:</strong></p>
            <p class="uuid-display">${jobUuid}</p>
            <div id="order-list"></div>
            <button onclick="jobManager.showAddOrderModal()">+ Tambah Pesanan</button>
            <button onclick="jobManager.loadOrders('${jobUuid}')">Refresh Pesanan</button>
            <button onclick="jobManager.closeDetail()">Tutup</button>
        `

    this.loadOrders(jobUuid)
  }

  closeDetail() {
    document.getElementById('detail').innerHTML = `
            <h2>Detail Pesanan</h2>
            <p>Pilih pekerjaan untuk melihat detail pesanan</p>
            <div id="order-list"></div>
            <button onclick="jobManager.showAddOrderModal()">+ Pesanan</button>
            <button onclick="jobManager.showAddJobsModal()">+ Pekerjaan</button>
        `
  }

  // ========== ORDERS MANAGEMENT ==========
  async loadOrders(jobUuid) {
    try {
      const response = await fetch(`get_orders.php?uuid_kerjaan=${jobUuid}`)
      const orders = await response.json()
      this.renderOrders(orders)
    } catch (error) {
      console.error('Error loading orders:', error)
      this.showError('order-list', 'Error loading orders')
    }
  }

  renderOrders(orders) {
    const orderList = document.getElementById('order-list')
    orderList.innerHTML = '<h3>Daftar Pesanan:</h3>'

    if (orders.length === 0) {
      orderList.innerHTML += '<p>Belum ada pesanan</p>'
      return
    }

    orderList.innerHTML += orders
      .map(
        order => `
            <div class="card">
                <p class="uuid-display"><strong>UUID:</strong> ${order.uuid}</p>
                <p><strong>Jenis:</strong> ${order.jenis}</p>
                <p><strong>Jumlah Unit:</strong> ${order.jumlah_unit}</p>
                <p><strong>Status:</strong> ${
                  order.status === 'ps' ? 'Pasang' : 'Bongkar'
                } <i> ( ${order.jumlah_orang} Org )</i></p>
                <p><strong>Dibuat:</strong> ${order.tanggal}</p>
                <button class="btn-success" onclick="jobManager.showAddWorksModal('${
                  order.uuid
                }')">Add</button>
                <button class="btn-edit" onclick="jobManager.showEditOrderModal(${JSON.stringify(
                  order
                ).replace(/"/g, '&quot;')})">Edit</button>
                <button class="btn-danger" onclick="jobManager.deleteOrder('${
                  order.uuid
                }')">Hapus</button>
            </div>
        `
      )
      .join('')
  }

  // ========== MODAL MANAGEMENT ==========
  showModal(modalId, data = null) {
    const modal = document.getElementById(modalId)
    if (data) this.populateForm(modalId, data)
    modal.style.display = 'flex'
  }

  closeModal(modalId) {
    const modal = document.getElementById(modalId)
    modal.style.display = 'none'
    const form = modal.querySelector('form')
    if (form) form.reset()
  }

  // Modal shortcuts
  showAddOrderModal() {
    if (!this.selectedJobUuid) {
      alert('Pilih pekerjaan terlebih dahulu!')
      return
    }
    document.getElementById('uuid_kerjaan_display').textContent =
      this.selectedJobUuid
    document.getElementById('id_kerjaan').value = this.selectedJobId
    this.showModal('addOrderModal')
  }

  showEditOrderModal(order) {
    this.selectedOrderUuid = order.uuid
    this.populateForm('editOrderModal', order, 'edit_')
    this.showModal('editOrderModal')
  }

  showAddJobsModal() {
    this.showModal('addJobsModal')
  }

  showEditJobModal(jobUuid) {
    // Implementasi pengisian data job untuk edit
    this.showModal('editJobsModal')
  }

  showAddWorksModal(orderUuid) {
    this.selectedOrderUuid = orderUuid
    document.getElementById('kerjaan_uuid_display').textContent = orderUuid
    document.getElementById('kerjaan_uuid').value = orderUuid
    this.loadAvailableUsers()
    this.loadWorkers()
    this.showModal('addWorksModal')
  }

  // ========== FORM HANDLERS ==========
  async handleAddOrder(e) {
    e.preventDefault()
    await this.submitForm('php/order_save.php', new FormData(e.target))
    this.closeModal('addOrderModal')
    this.loadOrders(this.selectedJobUuid)
  }

  async handleEditOrder(e) {
    e.preventDefault()
    const formData = new FormData(e.target)
    formData.append('uuid', this.selectedOrderUuid)
    await this.submitForm('php/order_edit.php', formData)
    this.closeModal('editOrderModal')
    this.loadOrders(this.selectedJobUuid)
  }

  async handleAddJob(e) {
    e.preventDefault()
    const formData = {
      pengguna: document.getElementById('pengguna').value,
      lokasi: document.getElementById('lokasi').value,
      status_pembayaran: document.getElementById('status_pembayaran').value,
      tanggal: document.getElementById('tanggal_job').value
    }

    await this.submitForm('php/job_save.php', formData, 'JSON')
    this.closeModal('addJobsModal')
    this.loadJobs()
  }

  async handleAddWorker(e) {
    e.preventDefault()
    const formData = new FormData(e.target)
    const jsonData = Object.fromEntries(formData)

    await this.submitForm('php/pekerja_save.php', jsonData, 'JSON')
    this.loadWorkers()
    this.loadAvailableUsers()
  }

  // ========== UTILITY METHODS ==========
  async submitForm(url, data, type = 'FORM') {
    try {
      const options = {
        method: 'POST',
        headers:
          type === 'JSON' ? { 'Content-Type': 'application/json' } : undefined,
        body: type === 'JSON' ? JSON.stringify(data) : data
      }

      const response = await fetch(url, options)
      const result =
        type === 'FORM'
          ? await response.json()
          : await response.text().then(text => JSON.parse(text))

      if (result.success) {
        alert('✅ Data berhasil disimpan!')
        return result
      } else {
        throw new Error(result.message || 'Error dari server')
      }
    } catch (error) {
      console.error('Submit error:', error)
      alert('❌ Error: ' + error.message)
      throw error
    }
  }

  populateForm(modalId, data, prefix = '') {
    Object.keys(data).forEach(key => {
      const element = document.getElementById(prefix + key)
      if (element) element.value = data[key]
    })
  }

  showError(elementId, message) {
    document.getElementById(elementId).innerHTML = `<p>${message}</p>`
  }

  // ========== DELETE OPERATIONS ==========
  async deleteOrder(orderUuid) {
    if (!confirm('Apakah Anda yakin ingin menghapus pesanan ini?')) return

    try {
      const response = await fetch(`delete_order.php?uuid=${orderUuid}`, {
        method: 'DELETE'
      })
      const data = await response.json()

      if (data.success) {
        this.loadOrders(this.selectedJobUuid)
        alert('Pesanan berhasil dihapus!')
      } else {
        alert('Error: ' + data.message)
      }
    } catch (error) {
      console.error('Error:', error)
      alert('Error menghapus pesanan')
    }
  }

  async deleteJob(jobUuid) {
    if (!confirm('Apakah Anda yakin ingin menghapus pekerjaan ini?')) return

    try {
      const response = await fetch(`php/job_delete.php?uuid=${jobUuid}`, {
        method: 'DELETE'
      })
      const data = await response.json()

      if (data.success) {
        this.loadJobs()
        alert('Pekerjaan berhasil dihapus!')
      } else {
        alert('Error: ' + data.message)
      }
    } catch (error) {
      console.error('Error:', error)
      alert('Error menghapus pekerjaan')
    }
  }

  // ========== WORKERS MANAGEMENT ==========
  async loadAvailableUsers() {
    try {
      const response = await fetch('users.php')
      const users = await response.json()
      const userSelect = document.getElementById('user_id')

      userSelect.innerHTML = '<option value="">Pilih Pekerja</option>'
      users.forEach(user => {
        const option = document.createElement('option')
        option.value = user.id
        option.textContent = `${user.nama_lengkap} (${user.username})`
        userSelect.appendChild(option)
      })
    } catch (error) {
      console.error('Error loading users:', error)
    }
  }

  async loadWorkers() {
    if (!this.selectedOrderUuid) return

    try {
      const response = await fetch(
        `php/workers_get.php?kerjaan_uuid=${this.selectedOrderUuid}`
      )
      const data = await response.json()
      const container = document.getElementById('workers-container')

      container.innerHTML = data.success
        ? data.workers
            .map(
              worker => `
                    <div class="card">
                        <p><strong>---:</strong> ${worker.nama_lengkap}</p>
                    </div>
                `
            )
            .join('')
        : '<p>Belum ada pekerja yang ditambahkan</p>'
    } catch (error) {
      console.error('Error loading workers:', error)
    }
  }
}

// Initialize application
const jobManager = new JobManager()
