import '../models/crm_activity_models.dart';
import '../models/crm_models.dart';
import '../models/crm_sequence_models.dart';

/// Mock-data seam for the CRM module.
///
/// Each method marks the HTTP call that replaces it:
///   organizations()  -> GET    /crm/organizations
///   contacts()       -> GET    /crm/contacts
///   opportunities()  -> GET    /crm/opportunities
///   owners           -> GET    /crm/owners
/// Writes (create/update/delete) live in `CrmLogic` with matching comments.
class CrmMockData {
  CrmMockData._();

  /// Pipeline ships empty to match the reference ($0 / zero counts).
  /// Flip to true to preview populated board/list states.
  static const bool seedDemoOpportunities = false;

  /// GET /crm/owners
  static const List<String> owners = [
    'Organization Admin',
    'Site-Work',
    'Vendor Contact',
  ];

  /// GET /crm/organizations
  static List<OrganizationModel> organizations() => const [
        OrganizationModel(
          id: 'org-1',
          name: 'Buckeye Concrete',
          type: OrgType.vendor,
          street: '123 Main St',
          city: 'Columbus',
          state: 'Ohio',
          zip: '43211',
          ownerName: 'Organization Admin',
          specialties: ['Concrete-Supplier'],
        ),
        OrganizationModel(
          id: 'org-2',
          name: 'Stump and Dailey',
          type: OrgType.subcontractor,
          city: 'Columbus',
          state: 'Ohio',
          ownerName: 'Site-Work',
          ownerRole: 'Cost Estimator',
          // Drives the "Active on Projects: 1" stat in the reference.
          relatedProjects: ['Riverside Warehouse'],
        ),
        OrganizationModel(
          id: 'org-3',
          name: 'new Test general contractor',
          type: OrgType.gcContractor,
        ),
        OrganizationModel(
          id: 'org-4',
          name: 'test',
          type: OrgType.ownerRep,
        ),
        OrganizationModel(
          id: 'org-5',
          name: 'test vendor',
          type: OrgType.vendor,
          city: 'LA',
          state: 'LA',
          ownerName: 'Vendor Contact',
          category: 'cement',
          complianceItems: [
            ComplianceItem(
              label: 'Contract',
              state: ComplianceItemState.expired,
            ),
          ],
        ),
      ];

  /// GET /crm/contacts
  static List<ContactModel> contacts() => const [
        ContactModel(
          id: 'contact-1',
          name: 'Kevin Hill',
          isPrimary: true,
          role: 'Sales',
          organizationName: 'Buckeye Concrete',
          email: 'kevin@buckeye.com',
        ),
      ];

  /// GET /crm/opportunities
  static List<OpportunityModel> opportunities() {
    if (!seedDemoOpportunities) return [];
    final now = DateTime.now();
    DateTime ago(int days) => now.subtract(Duration(days: days));
    DateTime ahead(int days) => now.add(Duration(days: days));
    return [
      OpportunityModel(
        id: 'opp-1',
        title: 'Riverside Warehouse Slab',
        organizationName: 'Buckeye Concrete',
        stage: OpportunityStage.estimating,
        value: 185000,
        assignee: 'Organization Admin',
        source: 'web_form',
        createdAt: ago(21),
        expectedCloseDate: ahead(20),
        stageHistory: [
          StageTransition(stage: OpportunityStage.lead, enteredAt: ago(21)),
          StageTransition(stage: OpportunityStage.qualified, enteredAt: ago(14)),
          StageTransition(stage: OpportunityStage.estimating, enteredAt: ago(6)),
        ],
      ),
      OpportunityModel(
        id: 'opp-2',
        title: 'Downtown Parking Deck',
        organizationName: 'Stump and Dailey',
        stage: OpportunityStage.bidSubmitted,
        value: 420000,
        assignee: 'Site-Work',
        source: 'referral',
        createdAt: ago(40),
        expectedCloseDate: ahead(45),
        stageHistory: [
          StageTransition(stage: OpportunityStage.lead, enteredAt: ago(40)),
          StageTransition(stage: OpportunityStage.qualified, enteredAt: ago(31)),
          StageTransition(stage: OpportunityStage.estimating, enteredAt: ago(22)),
          StageTransition(stage: OpportunityStage.bidSubmitted, enteredAt: ago(9)),
        ],
      ),
      OpportunityModel(
        id: 'opp-3',
        title: 'Retail Fit-Out',
        organizationName: 'test vendor',
        stage: OpportunityStage.won,
        value: 64000,
        assignee: 'Organization Admin',
        source: 'web_form',
        createdAt: ago(25),
        closedAt: ago(4),
        stageHistory: [
          StageTransition(stage: OpportunityStage.lead, enteredAt: ago(25)),
          StageTransition(stage: OpportunityStage.qualified, enteredAt: ago(20)),
          StageTransition(stage: OpportunityStage.negotiation, enteredAt: ago(10)),
          StageTransition(stage: OpportunityStage.won, enteredAt: ago(4)),
        ],
      ),
      OpportunityModel(
        id: 'opp-4',
        title: 'School Gym Floor',
        organizationName: 'Buckeye Concrete',
        stage: OpportunityStage.lost,
        value: 98000,
        assignee: 'Site-Work',
        source: 'web_form',
        lostReason: 'Price too high',
        createdAt: ago(28),
        closedAt: ago(8),
        stageHistory: [
          StageTransition(stage: OpportunityStage.lead, enteredAt: ago(28)),
          StageTransition(stage: OpportunityStage.bidSubmitted, enteredAt: ago(15)),
          StageTransition(stage: OpportunityStage.lost, enteredAt: ago(8)),
        ],
      ),
      OpportunityModel(
        id: 'opp-5',
        title: 'Medical Office Shell',
        organizationName: 'Stump and Dailey',
        stage: OpportunityStage.qualified,
        value: 45000,
        source: 'cold_call',
        createdAt: ago(5),
        expectedCloseDate: ahead(70),
        stageHistory: [
          StageTransition(stage: OpportunityStage.lead, enteredAt: ago(5)),
          StageTransition(stage: OpportunityStage.qualified, enteredAt: ago(2)),
        ],
      ),
    ];
  }

  // ── Sequences ──

  /// GET /crm/sequences. Only the read-only Library templates are seeded;
  /// "My Sequences" starts empty like the reference.
  static List<SequenceModel> sequences() => const [
        SequenceModel(
          id: 'seq-tpl-1',
          name: 'New Lead Welcome',
          description: 'Introduce your company to a fresh inbound lead.',
          isTemplate: true,
          ownerName: 'Library',
          steps: [
            SequenceStep(type: SequenceStepType.email, title: 'Intro & capabilities'),
            SequenceStep(type: SequenceStepType.call, title: 'Discovery call', delayDays: 2),
            SequenceStep(type: SequenceStepType.email, title: 'Case study follow-up', delayDays: 3),
          ],
        ),
        SequenceModel(
          id: 'seq-tpl-2',
          name: 'Bid Follow-Up',
          description: 'Keep a submitted bid warm until you get a decision.',
          isTemplate: true,
          ownerName: 'Library',
          steps: [
            SequenceStep(type: SequenceStepType.email, title: 'Confirm bid received', delayDays: 1),
            SequenceStep(type: SequenceStepType.call, title: 'Check for questions', delayDays: 4),
            SequenceStep(type: SequenceStepType.task, title: 'Escalate to decision maker', delayDays: 5),
          ],
        ),
        SequenceModel(
          id: 'seq-tpl-3',
          name: 'Reactivate Dormant Vendor',
          description: 'Re-engage vendors with no activity in 90+ days.',
          isTemplate: true,
          ownerName: 'Library',
          steps: [
            SequenceStep(type: SequenceStepType.email, title: 'Checking in'),
            SequenceStep(type: SequenceStepType.text, title: 'Quick text nudge', delayDays: 5),
          ],
        ),
      ];

  // ── Tasks / Calls / Quotes ──

  /// Tasks and Quotes ship empty to match the reference empty states.
  /// Flip to true to preview populated lists.
  static const bool seedDemoTasks = false;
  static const bool seedDemoQuotes = false;

  /// GET /crm/tasks
  static List<CrmTaskModel> tasks() {
    if (!seedDemoTasks) return [];
    final now = DateTime.now();
    return [
      CrmTaskModel(
        id: 'task-1',
        title: 'Send revised bid to Buckeye Concrete',
        notes: 'Include the updated slab quantities.',
        dueDate: now.add(const Duration(days: 2)),
        priority: TaskPriority.high,
        organizationName: 'Buckeye Concrete',
        assignee: 'Organization Admin',
      ),
      CrmTaskModel(
        id: 'task-2',
        title: 'Follow up on expired contract',
        dueDate: now.subtract(const Duration(days: 3)),
        organizationName: 'test vendor',
        assignee: 'Vendor Contact',
      ),
      const CrmTaskModel(
        id: 'task-3',
        title: 'Intro call with new GC',
        priority: TaskPriority.low,
      ),
      const CrmTaskModel(
        id: 'task-4',
        title: 'Collect W-9 from Stump and Dailey',
        isDone: true,
        organizationName: 'Stump and Dailey',
      ),
    ];
  }

  /// GET /crm/calls
  ///
  /// The first two entries reproduce the reference. The third is only partly
  /// visible there (date + "Out"), so its other values are invented.
  static List<CallLogModel> calls() => [
        CallLogModel(
          id: 'call-1',
          dateTime: DateTime(2026, 8, 5, 20, 30),
          direction: CallDirection.outbound,
          outcome: CallOutcome.connected,
          durationSeconds: 180,
          number: '+15551239999',
          owner: 'Test Admin',
          notes: 'e2e-call-1785943834962',
        ),
        CallLogModel(
          id: 'call-2',
          dateTime: DateTime(2026, 8, 5, 20, 25),
          direction: CallDirection.outbound,
          outcome: CallOutcome.connected,
          durationSeconds: 180,
          number: '+15551239999',
          owner: 'Test Admin',
          notes: 'e2e-call-1785943530179',
        ),
        CallLogModel(
          id: 'call-3',
          dateTime: DateTime(2026, 5, 12, 18, 4),
          direction: CallDirection.outbound,
          outcome: CallOutcome.noAnswer,
          durationSeconds: 0,
          number: '+15551239999',
          owner: 'Test Admin',
        ),
      ];

  /// GET /crm/quotes
  static List<QuoteModel> quotes() {
    if (!seedDemoQuotes) return [];
    return [
      QuoteModel(
        id: 'quote-1',
        number: 'Q-0001',
        title: 'Riverside warehouse slab',
        organizationName: 'Buckeye Concrete',
        status: QuoteStatus.sent,
        validUntil: DateTime.now().add(const Duration(days: 30)),
        lineItems: const [
          QuoteLineItem(
            description: '6" slab on grade, 12,000 sf',
            quantity: 12000,
            unitPrice: 8.5,
          ),
          QuoteLineItem(
            description: 'Rebar placement',
            quantity: 1,
            unitPrice: 9500,
          ),
        ],
      ),
      const QuoteModel(
        id: 'quote-2',
        number: 'Q-0002',
        title: 'Site-work allowance',
        organizationName: 'Stump and Dailey',
        lineItems: [
          QuoteLineItem(
            description: 'Excavation and grading',
            quantity: 1,
            unitPrice: 24000,
          ),
        ],
      ),
    ];
  }
}
