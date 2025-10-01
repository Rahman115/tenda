// app.js - Updated version using ModalManager
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

  // ... (sisanya sama seperti sebelumnya - loadJobs, loadOrders, dll.)

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
                }', ${JSON.stringify(job).replace(
                  /"/g,
                  '&quot;'
                )})">Edit</button>
                <button class="btn-danger" onclick="jobManager.deleteJob('${
                  job.uuid
                }')">Hapus</button>
            </div>
        `
      )
      .join('')
  }

  // ... (methods lainnya tetap sama)
}

// Initialize application
const jobManager = new JobManager()
