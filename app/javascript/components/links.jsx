import React from 'react'
import PropTypes from 'prop-types'

const Links = props => (
  <div>Hello {props.name}!</div>
)

Links.defaultProps = {
  name: 'Vini'
}

Links.propTypes = {
  name: PropTypes.string
}
 export default Links;
