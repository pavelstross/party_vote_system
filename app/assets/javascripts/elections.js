var app = app || (app = {});

(function(app) {
    function Component(el, selectors, options) {
        this.$el = $(el);
        this.ui = {};
        this.selectors = _.defaults(selectors || {}, {
            election_type: '.election_type',
            eligible_seats: '.eligible_seats',
            scope_type: '.scope_type',
            scope_id_region: '.scope_id_region',
            preparation_starts_at: '.preparation_starts_at',
            preparation_ends_at: '.preparation_ends_at'
        });
        this.options = options || {};
        this.initialize.apply(this, this.options);
    }

    var ComponentProto = Component.prototype;

    ComponentProto.initialize = function() {
        this.ui.election_type = this.$el.find(this.selectors.election_type);
        this.ui.eligible_seats = this.$el.find(this.selectors.eligible_seats);
        this.ui.scope_type = this.$el.find(this.selectors.scope_type);
        this.ui.scope_id_region = this.$el.find(this.selectors.scope_id_region);
        this.ui.preparation_starts_at = this.$el.find(this.selectors.preparation_starts_at);
        this.ui.preparation_ends_at = this.$el.find(this.selectors.preparation_ends_at);
        this.bind();
    };

    ComponentProto.bind = function() {
        var _this = this;

        this.ui.election_type.find('select').on('change', function(e) {
            var show = $(e.currentTarget).val() != 'resolution';
            _this.ui.eligible_seats.toggle(show);
            _this.ui.preparation_starts_at.toggle(show);
            _this.ui.preparation_ends_at.toggle(show);
        });

        this.ui.scope_type.find('select').on('change', function() {
            _this.ui.scope_id_region.toggle(_this.ui.scope_type.find('select').val() == 'region');
        });

        this.ui.election_type.find('select').trigger('change');
        this.ui.scope_type.find('select').trigger('change');
    };

    app.elections = Component;
})(app);
